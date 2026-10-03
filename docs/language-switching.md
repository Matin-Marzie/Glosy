# Atomic language switching

How the app switches the user's current learning language. On the phone
the switch is **atomic**: the local state is either fully the old language
or fully the new one (dictionary, current language, vocabulary, sentences),
never a mix. If anything fails, nothing changes and the user sees an error.
The phone and the server can briefly disagree in two rare cases - see
[What is and isn't guaranteed](#what-is-and-isnt-guaranteed).

Code:
- `frontend/components/LanguageSwitchSheet.tsx` - `handleSelect`, `runPendingSwitch`
- `frontend/context/DictionaryContext.js` - `prefetchDictionary`, `clearDictionary`, `applyPrefetchedDictionary`
- `frontend/utils/learningLanguageChangeLimit.js` - client-side change limit

## Overview

Every network request runs **before** anything local changes: the sync,
the dictionary download and the server switch. Only when all of them
succeed are the local updates applied, after the sheet has closed. Applying
them needs no network - the new dictionary is already in memory.

```mermaid
flowchart TD
    A([User taps a language in the sheet]) --> B{Under the change limit?<br/>20 changes / 15 min}
    B -- no --> E1[/"You've changed languages too many times..."/]
    B -- yes --> C[Lock the sheet<br/>row spinner, can't close, Add a language disabled]
    C --> D{Signed in?}
    D -- yes --> S["Sync pending changes<br/>POST /user/sync (only if something is pending)"]
    S -- fails --> E2
    S -- ok --> P
    D -- guest --> P
    P["Prefetch the new dictionary<br/>fresh phone cache, or GET /dictionary/:learning/:native<br/>expanded and held in memory, not shown yet"]
    P -- fails --> E2
    P -- ok --> Q{Signed in?}
    Q -- yes --> W["Switch on the server<br/>PATCH /language/current<br/>returns the new vocabulary + sentences"]
    W -- fails --> E2
    W -- ok --> R
    Q -- guest --> R
    R[Collect all local updates into one function<br/>nothing applied yet] --> X[Close the sheet]
    X --> Y["After the close animation (onDismiss, 1.5s fallback):<br/>clear, then fill with the already-downloaded data<br/>no network - see below"]
    Y --> Z([Screens render the new language once])

    E2[/"Changing language is not possible at this point.<br/>Please try again later."<br/>Nothing changed, sheet stays open/]

    style E1 fill:#fdecea,stroke:#d32f2f,color:#000
    style E2 fill:#fdecea,stroke:#d32f2f,color:#000
    style Z fill:#e3f4f4,stroke:#0f8690,color:#000
```

## Step by step

```mermaid
sequenceDiagram
    autonumber
    actor U as User
    participant S as LanguageSwitchSheet
    participant D as DictionaryContext
    participant AS as AsyncStorage
    participant API as Backend API
    participant R as App state & screens

    U->>S: tap language
    S->>S: check changeLearningLanguageLimit
    S->>S: setSwitchingId (spinner, sheet locked)

    opt signed in
        S->>API: POST /user/sync (pending changes for the OLD language)
        API-->>S: ok
    end

    S->>D: prefetchDictionary(learning, native)
    D->>AS: getItem(dictionary:learning:native)
    alt fresh cache on the phone
        AS-->>D: cached dictionary
    else no cache / expired
        D->>API: GET /dictionary/:learning/:native
        API-->>D: dictionary (columnar JSON)
    end
    D->>D: expand ~13k words, keep in prefetchedRef
    D-->>S: ok

    opt signed in
        S->>API: PATCH /language/current
        API-->>S: user_progress, user_vocabulary, user_sentences
    end

    Note over S: Any failure above: show the error, change nothing.<br/>No network requests after this point.

    S->>S: build applySwitch(), record the change for the limit
    S->>U: close the sheet
    U-->>S: onDismiss (close animation finished)

    rect rgb(240, 248, 248)
        Note over S,R: Clear, then fill
        S->>D: clearDictionary()
        D->>R: dictionary = null (cheap render, empty list)
        Note over R: old dictionary + its indexes<br/>become garbage
        S->>S: wait 50ms
        S->>D: applyPrefetchedDictionary() (from memory)
        S->>R: setUserProgress, vocabulary SET, sentences SET, clear change-sets
        Note over R: one synchronous block, one render
    end

    D-)AS: writeCache (background), then delete other dictionary:* pairs
    R->>D: auto-fetch effect sees the new language
    D-->>R: skipped, already shown
```

## Clear, then fill

The new data is applied in two steps, so the old and the new dictionary are
never in memory at the same time. Each dictionary has around 13-14k words,
plus the indexes built from it, so keeping only one at a time keeps memory
and garbage collection low.

Both steps are local. The new dictionary was already downloaded (or read
from the phone's cache) by `prefetchDictionary` before the clear, so losing
the internet connection between the clear and the fill changes nothing.

```mermaid
flowchart LR
    a1["Clear<br/>dictionary = null<br/>cheap render, empty list"] --> a2["Old dictionary and its indexes<br/>are no longer referenced"]
    a2 --> a3["50ms later: fill from memory<br/>new dictionary, language,<br/>vocabulary, sentences"]
    a3 --> a4["One render with the new data<br/>only one dictionary in memory"]
```

## What is and isn't guaranteed

Guaranteed:

- **No partial state on the phone**: the sync, the dictionary download and
  the server switch all succeed before any local state changes. If one of
  them fails, the current language, vocabulary, sentences and dictionary
  stay exactly as they were.
- **No network needed to apply**: clear and fill only use data that is
  already in memory, so a lost connection after the server switch can't
  leave the phone without a dictionary.
- **One render**: dictionary, current language, vocabulary and sentences are
  applied in one synchronous block, so screens never match the new
  vocabulary against the old dictionary.
- **No double download**: the auto-fetch that follows the switch finds the
  pair already shown and does nothing.
- **Locked sheet**: while a switch or add is running, swipe-down, backdrop
  tap and the Android back button can't close the sheet, and "Add a
  language" is disabled.
- **Rate limit**: the app allows 20 language changes per 15 minutes, the same
  as the backend's dictionary limit (20 requests per 15 minutes per IP).
- **One pair on the phone**: after the new dictionary is cached, other
  cached pairs are deleted.

Not guaranteed - the phone and the server can briefly disagree (signed-in
users only):

- **The server switches but the response is lost**: if the connection drops
  after the server has processed `PATCH /language/current`, the app shows
  the error and stays on the old language, while the server is already on
  the new one.
- **The app is killed between the server switch and the fill**: this window
  is about 0.7s (the sheet's close animation plus 50ms). The server has the
  new language, the phone still has the old one saved.

In both cases the phone's own state is still consistent (fully the old
language), and the two sides are back in sync the next time the app loads
the user's progress from the server, e.g. on the next login.
