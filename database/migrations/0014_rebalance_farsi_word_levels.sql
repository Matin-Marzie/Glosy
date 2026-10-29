-- Rebalances Farsi word levels. B1 held 4,329 words (30% of the dictionary)
-- while C1 had only 970, so the levels no longer grew the way CEFR vocab
-- does (each level adding more words than the one before). Target sizes:
--   B1 ~2,100  B2 ~2,400  C1 ~2,800  C2 ~3,200
-- A2 was meant to shrink to ~1,600 by promoting its most frequent words to
-- A1, but those promotions were dropped on review. A1 still sends its least
-- frequent words up to A2, so A1 ends at 694 and A2 at 1,906.
-- 'N' (alphabet/starter words) and 'EX' (place names, nationalities,
-- specialist terms) are deliberately left untouched.
--
-- How the new levels were chosen: every A1-C2 word got a score blending its
-- current level's position (70%) with its rank in the Persian
-- OpenSubtitles frequency list (30%; hermitdave/FrequencyWords 2018 fa,
-- matched after stripping diacritics, using the non-verbal part of compound
-- verbs and summed conjugations for simple verbs). Words were then sorted
-- by score and cut at the target sizes. Entries with a sense qualifier in
-- parentheses, and words absent from the list, kept their current-level
-- position only, since a base word's frequency says nothing about a rarer
-- sense. A2 words never move down to A1, and A1 words could move up at
-- most one level, because the subtitle corpus under-counts classroom
-- compounds like toothpaste or coloured pencil.
--
-- Only words whose level changes are listed. Each row is matched on id,
-- written_form and the old level, so rows that drifted from the seed file
-- or were already re-levelled are skipped and re-running is a no-op.
-- Existing user_vocabulary rows are not touched; only future proficiency
-- seeding sees the new levels.
UPDATE words w
SET level = v.new_level
FROM (VALUES
  (200400, 'آب‌میوه', 'A1', 'A2'), -- juice
  (200404, 'آدامس', 'A1', 'A2'), -- gum
  (200407, 'آسان', 'A1', 'A2'), -- easy
  (200409, 'آشپَزخانه', 'A1', 'A2'), -- kitchen
  (200410, 'آشپَزخانِه', 'A1', 'A2'), -- kitchen
  (200418, 'آناناس', 'A1', 'A2'), -- pineapple
  (200420, 'آنلاین', 'A1', 'A2'), -- online
  (200425, 'آواز خواندَن', 'A1', 'A2'), -- to sing
  (200429, 'اَبری', 'A1', 'A2'), -- cloudy
  (200430, 'اَحوال‌پُرسی', 'A1', 'A2'), -- greeting
  (200431, 'اَرزان', 'A1', 'A2'), -- cheap
  (200434, 'اَز آشنایی‌تون خوشوَقتَم', 'A1', 'A2'), -- pleased to meet you!
  (200435, 'اَسباب بازی', 'A1', 'A2'), -- toy
  (200436, 'اَسباب‌بازی', 'A1', 'A2'), -- toy
  (200446, 'اَپلیکِیشَن', 'A1', 'A2'), -- application
  (200448, 'اُتو کَردَن', 'A1', 'A2'), -- to iron
  (200449, 'اُتومُبیل', 'A1', 'A2'), -- car
  (200450, 'اُجاق گاز', 'A1', 'A2'), -- stove
  (200461, 'اِسکاج', 'A1', 'A2'), -- sponge
  (200471, 'ایشالا!', 'A1', 'A2'), -- Inshallah!
  (200477, 'اینستاگرام', 'A1', 'A2'), -- instagram
  (200483, 'باران آمَدَن', 'A1', 'A2'), -- to rain
  (200495, 'به پیکنیک رَفتَن', 'A1', 'A2'), -- to go on a picnic
  (200496, 'به کوه رَفتَن', 'A1', 'A2'), -- to go mountain climbing
  (200499, 'بور', 'A1', 'A2'), -- fair-haired
  (200504, 'بَرادَرزادِه', 'A1', 'A2'), -- nephew / niece / brother's child
  (200507, 'بَرف بازی', 'A1', 'A2'), -- playing in snow
  (200521, 'بَعضی وَقتها', 'A1', 'A2'), -- sometimes
  (200522, 'بَعضی‌ها', 'A1', 'A2'), -- some people
  (200527, 'بَنَفش', 'A1', 'A2'), -- purple
  (200532, 'بُلوز', 'A1', 'A2'), -- blouse
  (200542, 'بِلیت', 'A1', 'A2'), -- ticket
  (200553, 'بی‌زَحمَت', 'A1', 'A2'), -- please
  (200557, 'تاجیکِستان', 'A1', 'A2'), -- Tajikistan
  (200560, 'تایِخ', 'A1', 'A2'), -- date / history
  (200561, 'تایپ کَردَن', 'A1', 'A2'), -- to type
  (200564, 'توییتر', 'A1', 'A2'), -- twitter
  (200567, 'تَخفیف', 'A1', 'A2'), -- discount
  (200572, 'تَقویم', 'A1', 'A2'), -- calendar
  (200583, 'تَکلیف', 'A1', 'A2'), -- homework / task
  (200589, 'ثَبت‌نام کَردَن', 'A1', 'A2'), -- to register
  (200595, 'جَدوَل', 'A1', 'A2'), -- table / grid
  (200633, 'خَط‌کِش', 'A1', 'A2'), -- ruler
  (200653, 'دوغ', 'A1', 'A2'), -- doogh (yogurt drink)
  (200657, 'دَرس خواندَن', 'A1', 'A2'), -- to study
  (200668, 'دُوچَرخِه سَواری', 'A1', 'A2'), -- cycling / bike riding
  (200669, 'دُوچَرخِه سَواری کَردَن', 'A1', 'A2'), -- to ride a bicycle
  (200675, 'دیزی', 'A1', 'A2'), -- Dizi (traditional Iranian stew)
  (200683, 'رایانِه', 'A1', 'A2'), -- computer
  (200690, 'رُبع', 'A1', 'A2'), -- quarter
  (200691, 'رُوبِرُویِ', 'A1', 'A2'), -- opposite / facing
  (200702, 'زِمِستان', 'A1', 'A2'), -- winter
  (200706, 'زِیتون', 'A1', 'A2'), -- olive
  (200714, 'سَبزی', 'A1', 'A2'), -- herbs / vegetables
  (200715, 'سَبزیجات', 'A1', 'A2'), -- vegetables
  (200718, 'سَردَرد', 'A1', 'A2'), -- headache
  (200726, 'سُفره', 'A1', 'A2'), -- tablecloth / spread
  (200727, 'سِرویس بَهداشتی', 'A1', 'A2'), -- bathroom / restroom
  (200730, 'سیب‌زَمینی', 'A1', 'A2'), -- potato
  (200740, 'شَربَت', 'A1', 'A2'), -- syrup / sherbet
  (200761, 'عابِربانک', 'A1', 'A2'), -- ATM
  (200768, 'عَزیزان', 'A1', 'A2'), -- loved ones / dear ones
  (200796, 'قُرمِه سَبزی', 'A1', 'A2'), -- Ghormeh sabzi (Iranian dish)
  (200801, 'لینک', 'A1', 'A2'), -- link
  (200805, 'ماکارونی', 'A1', 'A2'), -- spaghetti
  (200806, 'مایِعِ ظَرفشویی', 'A1', 'A2'), -- dish wash liquid
  (200810, 'مورِدِعَلاقِه', 'A1', 'A2'), -- favorite
  (200820, 'مَسجِد', 'A1', 'A2'), -- mosque
  (200821, 'مَعذِرَت خواستَن', 'A1', 'A2'), -- to apologize
  (200843, 'مُشَخَّصاتِ فَردی', 'A1', 'A2'), -- personal information
  (200863, 'مِداد', 'A1', 'A2'), -- pencil
  (200864, 'مِداد‌رَنگی', 'A1', 'A2'), -- coloured pencil
  (200865, 'مِسواک', 'A1', 'A2'), -- toothbrush
  (200866, 'مِسواک‌زَدَن', 'A1', 'A2'), -- to brush the teeth
  (200867, 'مِلّیَّت', 'A1', 'A2'), -- nationality
  (200869, 'مِهربان', 'A1', 'A2'), -- kind
  (200870, 'مِهرَبان', 'A1', 'A2'), -- kind / gentle
  (200874, 'میزِ تَحریر', 'A1', 'A2'), -- desk
  (200877, 'میوِه خُشک', 'A1', 'A2'), -- dried fruit
  (200880, 'نادُرُست', 'A1', 'A2'), -- false / incorrect
  (200884, 'نامُرَتَّب', 'A1', 'A2'), -- untidy
  (200885, 'نامِ خانِوادِگی', 'A1', 'A2'), -- family name
  (200886, 'نامِ کاربَری', 'A1', 'A2'), -- username
  (200891, 'نوروز', 'A1', 'A2'), -- Nowruz (Persian New Year)
  (200904, 'نُوروز', 'A1', 'A2'), -- Nowruz
  (200905, 'نِسکافه', 'A1', 'A2'), -- coffee mix
  (200914, 'نیمرو', 'A1', 'A2'), -- fried eggs
  (200918, 'هَرروز', 'A1', 'A2'), -- everyday
  (200927, 'هَمسَفَر', 'A1', 'A2'), -- fellow traveler / travel companion
  (200936, 'هَم‌کِلاسی', 'A1', 'A2'), -- classmate
  (200941, 'هَویج', 'A1', 'A2'), -- carrot
  (200950, 'واتساپ', 'A1', 'A2'), -- WhatsApp
  (200954, 'واژِه', 'A1', 'A2'), -- word
  (200958, 'وَرزِشکار', 'A1', 'A2'), -- sportsman
  (200964, 'وَسیلِه نَقلیِه', 'A1', 'A2'), -- transportation
  (200974, 'ویلا', 'A1', 'A2'), -- villa
  (200975, 'ویکی‌پِدیا', 'A1', 'A2'), -- Wikipedia
  (200980, 'پالتو', 'A1', 'A2'), -- coat / overcoat
  (200982, 'پانصَد', 'A1', 'A2'), -- five hundred
  (200983, 'پاییز', 'A1', 'A2'), -- Fall / Autumn
  (200998, 'پیک‌نیک رَفتَن', 'A1', 'A2'), -- to go on a picnic
  (201006, 'چِراغ راهنَمایی', 'A1', 'A2'), -- traffic light
  (201011, 'چِلوکَباب', 'A1', 'A2'), -- Kebabs (rice with grilled meat)
  (201020, 'چیپس', 'A1', 'A2'), -- chips
  (201021, 'ژوئن', 'A1', 'A2'), -- June
  (201024, 'کارتِ اِعتِباری', 'A1', 'A2'), -- credit card
  (201032, 'کاپشِن', 'A1', 'A2'), -- jacket / coat
  (201033, 'کوبیدِه', 'A1', 'A2'), -- Kubide (minced meat kebab)
  (201037, 'کَبابی', 'A1', 'A2'), -- kebab shop / grilled
  (201047, 'کُرونا', 'A1', 'A2'), -- Corona (virus)
  (201051, 'کِتابخانِه', 'A1', 'A2'), -- library
  (201054, 'کِلیک', 'A1', 'A2'), -- click
  (201062, 'گوجه', 'A1', 'A2'), -- tomato
  (201064, 'گوشیِ هوشمَند', 'A1', 'A2'), -- smartphone
  (201065, 'گوگِل', 'A1', 'A2'), -- Google
  (201067, 'گَردگیری', 'A1', 'A2'), -- dusting
  (201074, 'گُشنِه', 'A1', 'A2'), -- hungry (colloquial)
  (201076, 'گُلِ سُرخ', 'A1', 'A2'), -- rose
  (201078, 'گِلو', 'A1', 'A2'), -- throat
  (201085, 'یَکدیگَر', 'A1', 'A2'), -- each other / one another
  (201088, 'آبان', 'A2', 'B1'), -- The eighth month of the solar year
  (201095, 'آرایِشگَری', 'A2', 'B1'), -- hair dressing
  (201108, 'آفیس', 'A2', 'B1'), -- Office (software)
  (201154, 'اَنگُشتَری', 'A2', 'B1'), -- ring (finger ring)
  (201159, 'اُردیبِهِشت', 'A2', 'B1'), -- The second month of the solar year
  (201184, 'اِستِمراری', 'A2', 'B2'), -- continuous
  (201185, 'اِستیکِر', 'A2', 'B1'), -- sticker
  (201186, 'اِسفَند', 'A2', 'B1'), -- The last month of the solar year
  (201198, 'اِنشا', 'A2', 'B1'), -- composition
  (201201, 'ایروبیک', 'A2', 'B1'), -- aerobics
  (201208, 'باتَعَجُّب', 'A2', 'B2'), -- surprisingly
  (201215, 'باسَواد', 'A2', 'B1'), -- literate
  (201217, 'باعَجَله', 'A2', 'B1'), -- in a hurry
  (201223, 'بانجی جامپینگ', 'A2', 'B1'), -- bungee jumping
  (201225, 'به نُدرَت', 'A2', 'B1'), -- rarely
  (201226, 'بوستان', 'A2', 'B1'), -- park / garden
  (201243, 'بَلخ', 'A2', 'B1'), -- Balkh
  (201260, 'بِه خواستِگاری رَفتَن', 'A2', 'B1'), -- to propose (marriage)
  (201294, 'تَختِ جَمشید', 'A2', 'B1'), -- Persepolis
  (201303, 'تَزیین کَردَن', 'A2', 'B1'), -- to decorate
  (201324, 'تَنّوری', 'A2', 'B1'), -- tandoor / oven-baked
  (201347, 'جا ماندَن اَز ...', 'A2', 'B1'), -- to miss out on
  (201349, 'جابه‌جا کَردَن', 'A2', 'B1'), -- to move / to relocate
  (201353, 'جاروبَرقی', 'A2', 'B1'), -- vacuum cleaner
  (201371, 'جُغرافیا', 'A2', 'B1'), -- geography
  (201392, 'خانِه تَکانی', 'A2', 'B1'), -- housecleaning
  (201398, 'خودپَرداز', 'A2', 'B1'), -- ATM
  (201406, 'خَمیازِه کِشیدَن', 'A2', 'B1'), -- to yawn
  (201409, 'خُشکِبار', 'A2', 'B1'), -- dried fruits / nuts
  (201412, 'دوتَخته', 'A2', 'B1'), -- double-bedded
  (201413, 'دوخوابه', 'A2', 'B1'), -- two-bedroom
  (201418, 'دَبِستان', 'A2', 'B1'), -- elementary school
  (201445, 'دُعا خواندَن', 'A2', 'B1'), -- to pray
  (201451, 'دِلدَرد', 'A2', 'B1'), -- stomach ache
  (201462, 'رالی', 'A2', 'B1'), -- rally (sport)
  (201477, 'رَعدُوبَرق', 'A2', 'B1'), -- thunder and lightning
  (201484, 'رُوباز', 'A2', 'B1'), -- open / outdoor
  (201491, 'زَعفَرانی', 'A2', 'B1'), -- saffron-colored
  (201495, 'زِرِشک', 'A2', 'B1'), -- barberry
  (201498, 'زِیتون پَروَردِه', 'A2', 'B1'), -- marinated olives
  (201499, 'زیباتَرکَردَن', 'A2', 'B1'), -- to beautify
  (201511, 'سوغاتی', 'A2', 'B1'), -- souvenir
  (201514, 'سَردخانِه', 'A2', 'B1'), -- cold storage
  (201525, 'سُلطانی', 'A2', 'B1'), -- Soltani (type of kebab)
  (201526, 'سُماق', 'A2', 'B1'), -- sumac
  (201532, 'سِشوار', 'A2', 'B1'), -- hairdryer
  (201541, 'شَلغَم', 'A2', 'B1'), -- turnip
  (201554, 'شیشلیک', 'A2', 'B1'), -- shashlik / grilled meat
  (201560, 'صَدبَرابَر', 'A2', 'B1'), -- a hundred times
  (201566, 'صَنایعِ دَستی', 'A2', 'B1'), -- handicrafts
  (201570, 'ضِدِّعُفونی', 'A2', 'B1'), -- disinfection
  (201571, 'ضِدِّآفتَاب', 'A2', 'B1'), -- sunblock/sunscreen
  (201601, 'فَرهَنگ لُغَت', 'A2', 'B1'), -- dictionary
  (201604, 'فُتوشاپ', 'A2', 'B1'), -- Photoshop
  (201615, 'قالی', 'A2', 'B1'), -- carpet
  (201634, 'لُغَت‌نامِه', 'A2', 'B1'), -- dictionary
  (201638, 'لِذَّت‌بَخش', 'A2', 'B1'), -- enjoyable / pleasant
  (201639, 'لیسانس', 'A2', 'B1'), -- B.A. (degree) / bachelor's
  (201654, 'مَجلِسی', 'A2', 'B1'), -- party (adj) / ceremonial
  (201676, 'مَصدَر', 'A2', 'B1'), -- infinitive
  (201698, 'مُتَنَوِّع', 'A2', 'B1'), -- varied / diverse
  (201699, 'مُتَوَسِّطِه', 'A2', 'B1'), -- secondary / intermediate
  (201709, 'مُرداد', 'A2', 'B1'), -- The fifth month of the solar year
  (201710, 'مُرغِ مینا', 'A2', 'B1'), -- Myna (bird)
  (201718, 'مُشاوِرِ تَحصیلی', 'A2', 'B1'), -- education consultant
  (201723, 'مُضِر', 'A2', 'B1'), -- harmful
  (201725, 'مُعتَدِل', 'A2', 'B1'), -- mild
  (201728, 'مُفرَد', 'A2', 'B1'), -- singular
  (201733, 'مُقَوّایی', 'A2', 'B1'), -- cardboard
  (201749, 'مِلکی', 'A2', 'B1'), -- possessive
  (201756, 'میزبانی', 'A2', 'B1'), -- hosting
  (201762, 'ناتَمام', 'A2', 'B1'), -- incomplete / unfinished
  (201765, 'نامَوجود', 'A2', 'B1'), -- unavailable / nonexistent
  (201768, 'نوشتاری', 'A2', 'B1'), -- written
  (201772, 'نَجّاری', 'A2', 'B1'), -- carpentry
  (201785, 'نَهی', 'A2', 'B1'), -- negative imperative
  (201786, 'نَپُخته', 'A2', 'B1'), -- half-cooked / uncooked
  (201807, 'هَرسالِه', 'A2', 'B1'), -- annually / every year
  (201815, 'هَمِگانی', 'A2', 'B1'), -- public / universal
  (201828, 'واژِه سازی', 'A2', 'B1'), -- wordmaking
  (201829, 'ووشو', 'A2', 'B1'), -- wushu (martial art)
  (201836, 'وَقت‌گیر', 'A2', 'B1'), -- time-consuming
  (201839, 'وِبگَردی', 'A2', 'B1'), -- surfing the Net
  (201840, 'وِبگَردی کَردَن', 'A2', 'B2'), -- to surf the Net
  (201842, 'ویتِرین', 'A2', 'B1'), -- shop window
  (201848, 'پاساژ', 'A2', 'B1'), -- mall
  (201855, 'پَس‌فَردا', 'A2', 'B1'), -- the day after tomorrow
  (201860, 'پُرجَمعیَّت', 'A2', 'B1'), -- populated / populous
  (201871, 'پینت‌بال', 'A2', 'B1'), -- paintball
  (201876, 'چاپگَر', 'A2', 'B1'), -- printer
  (201885, 'ژیمناستیک', 'A2', 'B1'), -- gymnastics
  (201886, 'کارتخوان', 'A2', 'B1'), -- card reader
  (201887, 'کارتینگ', 'A2', 'B1'), -- karting / go-kart
  (201897, 'کَم‌رَنگ', 'A2', 'B1'), -- pale
  (201910, 'گارانتی', 'A2', 'B1'), -- warranty
  (201928, 'یونِسکو', 'A2', 'B1'), -- UNESCO
  (201933, 'آتَشفِشان', 'B1', 'B2'), -- volcano
  (201934, 'آتَش‌سوزی', 'B1', 'B2'), -- fire (blaze/conflagration)
  (201937, 'آداب', 'B1', 'B2'), -- customs
  (201938, 'آدامس بادکُنَکی', 'B1', 'C1'), -- bubble gum
  (201940, 'آرَنج', 'B1', 'B2'), -- elbow
  (201941, 'آزادراه', 'B1', 'C1'), -- freeway
  (201944, 'آسیایِ میانِه', 'B1', 'C1'), -- Central Asia
  (201945, 'آشامیدَنی', 'B1', 'B2'), -- drinking / potable
  (201951, 'آمپول زَدَن', 'B1', 'B2'), -- to give/have an injection
  (201952, 'آنقَدر', 'B1', 'B2'), -- so / so much
  (201953, 'آوازِه', 'B1', 'B2'), -- fame / reputation
  (201956, 'آیین', 'B1', 'B2'), -- ceremony / tradition
  (201958, 'ابتِدایِ', 'B1', 'B2'), -- beginning of
  (201959, 'اتِّفاق افتادَن', 'B1', 'A2'), -- to happen
  (201964, 'احساس', 'B1', 'A2'), -- feeling
  (201965, 'ادامه دادَن', 'B1', 'A2'), -- to continue
  (201969, 'اشتِها داشتَن', 'B1', 'B2'), -- to have appetite
  (201972, 'اطِّلاعات', 'B1', 'A2'), -- information
  (201975, 'اعضا', 'B1', 'B2'), -- members
  (201977, 'افراد', 'B1', 'A2'), -- people
  (201978, 'اَبعاد', 'B1', 'B2'), -- dimensions
  (201981, 'اَجزاء', 'B1', 'C1'), -- parts / components
  (201982, 'اَخذ کَردَن', 'B1', 'C1'), -- to obtain
  (201989, 'اَندَکی', 'B1', 'B2'), -- a little
  (201990, 'اَهدا کَردَن', 'B1', 'B2'), -- to donate / to dedicate
  (201991, 'اَهَمِّیَّت قائِل بودَن', 'B1', 'B2'), -- to attach importance to
  (202000, 'اِسکِناس', 'B1', 'B2'), -- banknotes
  (202004, 'اِنگار', 'B1', 'A2'), -- it seems / as if
  (202009, 'با اِحتیاط', 'B1', 'B2'), -- cautious/carefully
  (202010, 'با خونسَردی', 'B1', 'B2'), -- calmly
  (202011, 'باتَجرُبه', 'B1', 'B2'), -- experienced
  (202012, 'باخَبَر بودَن', 'B1', 'B2'), -- to be aware
  (202013, 'بارگُذاری', 'B1', 'B2'), -- upload
  (202014, 'بارگیری', 'B1', 'B2'), -- download
  (202015, 'بارگیری کَردَن', 'B1', 'B2'), -- to download
  (202016, 'بازارچه', 'B1', 'C1'), -- market
  (202018, 'بازدیدکُنَنده', 'B1', 'B2'), -- visitor
  (202019, 'بازیافت', 'B1', 'B2'), -- recycle
  (202020, 'باسَوادی', 'B1', 'C1'), -- literacy
  (202021, 'باعِث', 'B1', 'A2'), -- cause
  (202022, 'باعِث شُدَن', 'B1', 'A2'), -- to cause
  (202023, 'باوَر', 'B1', 'A2'), -- belief
  (202024, 'باوَر کَردَن', 'B1', 'A2'), -- to believe
  (202027, 'به‌دَست آوَردَن', 'B1', 'A2'), -- to gain/obtain
  (202031, 'به‌صورتِ', 'B1', 'C1'), -- in a ... way/-ly
  (202034, 'به‌عُنوانِ', 'B1', 'C1'), -- as
  (202035, 'به‌عِلاوه', 'B1', 'C1'), -- in addition
  (202039, 'بَداَخلاق', 'B1', 'B2'), -- bad tempered
  (202040, 'بَدَلکار', 'B1', 'B2'), -- stuntman
  (202041, 'بَدَلکاری', 'B1', 'C1'), -- stunt work
  (202044, 'بَرآوُردِه کَردَن', 'B1', 'B2'), -- to fulfill
  (202050, 'بَرقَراری', 'B1', 'B2'), -- establishment
  (202052, 'بَرگُزیدِه', 'B1', 'B2'), -- selected / chosen
  (202057, 'بُروشور', 'B1', 'B2'), -- brochure
  (202058, 'بُزُرگسال', 'B1', 'B2'), -- adult
  (202059, 'بُلبُل', 'B1', 'B2'), -- nightingale
  (202060, 'بُلَندگو', 'B1', 'B2'), -- speaker
  (202062, 'بِه تازِگی', 'B1', 'B2'), -- recently
  (202064, 'بِه روزرَسانی', 'B1', 'C1'), -- update
  (202065, 'بِه شُمار رَفتَن', 'B1', 'B2'), -- to be counted as
  (202071, 'بیکاری', 'B1', 'B2'), -- unemployment
  (202072, 'بی‌خوابی', 'B1', 'B2'), -- insomnia
  (202077, 'تأکید', 'B1', 'B2'), -- emphasis / stress
  (202080, 'تابِستانی', 'B1', 'B2'), -- summer (adj)
  (202081, 'تابیدَن', 'B1', 'B2'), -- to shine
  (202082, 'تاحُدودِ', 'B1', 'C1'), -- about
  (202083, 'تاریخِ اِنقِضا', 'B1', 'C1'), -- expiration date
  (202087, 'تاکُنون', 'B1', 'B2'), -- until now
  (202090, 'تَبدیل', 'B1', 'A2'), -- conversion
  (202093, 'تَبلیغ کَردَن', 'B1', 'B2'), -- to advertise
  (202097, 'تَجَمُّع', 'B1', 'B2'), -- gathering / assembly
  (202100, 'تَختِ دُوطَبَقه', 'B1', 'C1'), -- bunk bed
  (202101, 'تَخفیف گِرِفتَن', 'B1', 'B2'), -- to get a discount
  (202102, 'تَدوین', 'B1', 'B2'), -- compilation / authoring
  (202105, 'تَرجیحاً', 'B1', 'B2'), -- preferably
  (202112, 'تَصدیق', 'B1', 'B2'), -- confirmation / approval
  (202115, 'تَعارُف کَردَن', 'B1', 'B2'), -- to compliment
  (202118, 'تَعویض کَردَن', 'B1', 'B2'), -- to replace
  (202127, 'تَقویَّت کَردَن', 'B1', 'B2'), -- to strengthen / to reinforce
  (202128, 'تَلَقّی شُدَن', 'B1', 'B2'), -- to be considered as
  (202129, 'تَماشاگَر', 'B1', 'B2'), -- spectator
  (202133, 'تَنَوُّع', 'B1', 'B2'), -- variety / diversity
  (202134, 'تَهویه', 'B1', 'B2'), -- ventilation
  (202138, 'تَوصیف کَردَن', 'B1', 'B2'), -- to describe
  (202141, 'تَوَسُّطِ', 'B1', 'A2'), -- by
  (202142, 'تَکیه دادَن', 'B1', 'B2'), -- to lean on
  (202145, 'تیتَر', 'B1', 'B2'), -- headline
  (202146, 'تیزِر', 'B1', 'C1'), -- teaser / trailer
  (202151, 'جابه‌جایی', 'B1', 'C1'), -- movement
  (202154, 'جور', 'B1', 'A2'), -- sort
  (202155, 'جوهر', 'B1', 'B2'), -- ink
  (202156, 'جَدولِ کَلِماتِ مُتَقاطِع', 'B1', 'C1'), -- crossword puzzle
  (202159, 'جَشنواره‌ سینَمایی', 'B1', 'B2'), -- film festival
  (202169, 'جُغرافیایی', 'B1', 'B2'), -- geographic
  (202171, 'جِسمی', 'B1', 'B2'), -- physical
  (202177, 'حَداقَل', 'B1', 'A2'), -- at least
  (202180, 'حَسود', 'B1', 'B2'), -- jealous
  (202182, 'حَق', 'B1', 'A2'), -- right
  (202183, 'حَقیقَت', 'B1', 'A2'), -- truth
  (202189, 'حَک کَردَن', 'B1', 'B2'), -- to engrave / to inscribe
  (202193, 'حِساب', 'B1', 'A2'), -- account
  (202199, 'خواربار', 'B1', 'B2'), -- grocery
  (202201, 'خودآموز', 'B1', 'C1'), -- self-help
  (202202, 'خودشِناسی', 'B1', 'C1'), -- self-knowledge
  (202203, 'خودنِویس', 'B1', 'C1'), -- fountain pen
  (202206, 'خَبَرنِگاران', 'B1', 'B2'), -- reporters
  (202211, 'خَریداری کَردَن', 'B1', 'B2'), -- to buy
  (202212, 'خَطَرات', 'B1', 'B2'), -- dangers
  (202218, 'خِدمَتگُزاری', 'B1', 'C1'), -- service (giving)
  (202219, 'خِدَماتی', 'B1', 'B2'), -- service (adj)
  (202223, 'دودکِش', 'B1', 'B2'), -- chimney
  (202224, 'دودی', 'B1', 'B2'), -- sunglasses/smoky
  (202226, 'دوردَست', 'B1', 'B2'), -- far-off / distant
  (202234, 'دَر دَسترَس', 'B1', 'B2'), -- available
  (202235, 'دَر دَسترَس بودَن', 'B1', 'B2'), -- to be available
  (202237, 'دَر میلادِ مَسیح', 'B1', 'B2'), -- in A.D. (Anno Domini)
  (202243, 'دَرَختچه', 'B1', 'C1'), -- shrub/bush
  (202249, 'دَما', 'B1', 'B2'), -- temperature
  (202250, 'دُزدانِه', 'B1', 'C1'), -- stealthily / sneakily
  (202252, 'دُشوار', 'B1', 'B2'), -- tough/difficult
  (202256, 'دِرام', 'B1', 'B2'), -- drama
  (202257, 'دِرَنگ', 'B1', 'B2'), -- delay / pause
  (202260, 'دِلبـاختِه', 'B1', 'B2'), -- in love / enchanted
  (202261, 'دیرباز', 'B1', 'C1'), -- long time ago / for a long time
  (202263, 'دیواری', 'B1', 'B2'), -- wall (adj)
  (202265, 'ذَرّات', 'B1', 'B2'), -- particles
  (202269, 'رابِطه', 'B1', 'A2'), -- relationship
  (202272, 'راه اَنداختَن', 'B1', 'A2'), -- to launch
  (202273, 'راه اَندازی', 'B1', 'B2'), -- Setting up
  (202274, 'راه اُفتادَن', 'B1', 'A2'), -- to flow/to start moving
  (202277, 'راهِ‌حَل', 'B1', 'C1'), -- solution
  (202278, 'رایج', 'B1', 'B2'), -- common
  (202280, 'روبه‌رو شُدَن', 'B1', 'B2'), -- to face
  (202284, 'روزمره', 'B1', 'B2'), -- everyday/routine
  (202285, 'روزی روزگاری', 'B1', 'B2'), -- once upon a time
  (202288, 'رومِ باستان', 'B1', 'B2'), -- ancient Rome
  (202290, 'رویارویی', 'B1', 'B2'), -- confrontation / encounter
  (202291, 'رَحمَت', 'B1', 'B2'), -- mercy / blessing
  (202292, 'رَسانه ای', 'B1', 'B2'), -- media-related
  (202293, 'رَفتار', 'B1', 'A2'), -- behavior/manner
  (202295, 'رَوش', 'B1', 'A2'), -- way
  (202297, 'رِزومه', 'B1', 'B2'), -- CV
  (202298, 'ریزشِ مو', 'B1', 'B2'), -- hair fall
  (202300, 'ریشتِر', 'B1', 'B2'), -- Richter (scale)
  (202310, 'ساردین', 'B1', 'B2'), -- sardine
  (202314, 'سوئیت', 'B1', 'B2'), -- suite
  (202316, 'سوختِگی', 'B1', 'B2'), -- burn
  (202317, 'سونا', 'B1', 'B2'), -- sauna
  (202318, 'سونامی', 'B1', 'B2'), -- tsunami
  (202322, 'سَخت‌گیر', 'B1', 'B2'), -- strict / demanding
  (202326, 'سَرگیجه', 'B1', 'B2'), -- vertigo/dizziness
  (202332, 'سَیّار', 'B1', 'B2'), -- mobile / traveling
  (202334, 'سُرخرَنگ', 'B1', 'C1'), -- red
  (202338, 'سُکونَت', 'B1', 'B2'), -- residence / dwelling
  (202343, 'شاهکار', 'B1', 'B2'), -- masterpiece
  (202353, 'شَمسی', 'B1', 'B2'), -- solar
  (202354, 'شَهامَت', 'B1', 'B2'), -- bravery / courage
  (202359, 'شُعبه', 'B1', 'B2'), -- branch
  (202360, 'شُماره اِشتِراک', 'B1', 'B2'), -- subscription code
  (202362, 'شِبهِ قارِه', 'B1', 'B2'), -- subcontinent
  (202363, 'شِفاهی', 'B1', 'B2'), -- oral
  (202366, 'شِکَستِگی', 'B1', 'B2'), -- Fracture/break
  (202367, 'شیشِه گَر', 'B1', 'B2'), -- glazier
  (202369, 'شیوع', 'B1', 'B2'), -- prevalence / outbreak
  (202371, 'شیپور', 'B1', 'B2'), -- bugle
  (202375, 'صَمیمانه', 'B1', 'B2'), -- friendly
  (202376, 'صَندوقچه', 'B1', 'B2'), -- chest/box
  (202384, 'ظُروف', 'B1', 'B2'), -- dishes
  (202388, 'عَصرِ یَخبَندان', 'B1', 'C1'), -- ice age
  (202391, 'عَلاقه', 'B1', 'A2'), -- interest
  (202401, 'عَکاسی', 'B1', 'B2'), -- photography
  (202402, 'عُضویَّت', 'B1', 'B2'), -- membership
  (202403, 'عُلوم تَربیَتی', 'B1', 'C1'), -- educational sciences
  (202404, 'عُنوان', 'B1', 'A2'), -- title
  (202410, 'غَوّاصی', 'B1', 'B2'), -- diving / scuba diving
  (202412, 'غِیرِه', 'B1', 'B2'), -- etc.
  (202413, 'فارِغُ التَّحصیل', 'B1', 'B2'), -- graduate
  (202414, 'فارِغُ التَّحصیلی', 'B1', 'B2'), -- graduation
  (202417, 'فوتوشاپ', 'B1', 'C1'), -- photoshop
  (202419, 'فَرار کَردَن', 'B1', 'A2'), -- to escape
  (202420, 'فَراغَت', 'B1', 'B2'), -- leisure / free time
  (202421, 'فَراموشکار', 'B1', 'C1'), -- forgetful
  (202423, 'فَضایِ مَجازی', 'B1', 'B2'), -- cyberspace
  (202427, 'فَنّاوری', 'B1', 'B2'), -- technology
  (202428, 'فَوَران', 'B1', 'B2'), -- eruption
  (202430, 'فِیلَسوف', 'B1', 'B2'), -- philosopher
  (202431, 'فیزیکدان', 'B1', 'B2'), -- physicist
  (202432, 'فیش', 'B1', 'B2'), -- receipt/slip
  (202433, 'فیلمبَردار', 'B1', 'B2'), -- cameraman
  (202436, 'قاجار', 'B1', 'C1'), -- Qajar (dynasty)
  (202438, 'قاعِدِه', 'B1', 'B2'), -- rule / principle
  (202440, 'قَرار گِرِفتَن', 'B1', 'A2'), -- to be placed / to be situated
  (202449, 'قَواعِد', 'B1', 'B2'), -- rules / grammar rules
  (202451, 'قُدرَت', 'B1', 'A2'), -- power
  (202453, 'قُرون', 'B1', 'B2'), -- centuries
  (202454, 'قُرونِ وُسطیٰ', 'B1', 'B2'), -- Middle Ages
  (202456, 'قُطبی', 'B1', 'B2'), -- polar
  (202458, 'قُوم', 'B1', 'B2'), -- tribe / ethnic group
  (202459, 'قیف', 'B1', 'B2'), -- funnel
  (202468, 'ماهیَّت', 'B1', 'B2'), -- nature / essence
  (202470, 'مورِد', 'B1', 'A2'), -- item/case
  (202471, 'مورِدِنیاز', 'B1', 'C1'), -- requisite
  (202474, 'مَجبور', 'B1', 'A2'), -- to be forced
  (202477, 'مَخلوط‌کَردَن', 'B1', 'B2'), -- to blend/to mix
  (202478, 'مَداربَسته', 'B1', 'B2'), -- closed-circuit
  (202480, 'مَزایا', 'B1', 'B2'), -- advantages / benefits
  (202487, 'مَشوَرَت‌کَردَن', 'B1', 'B2'), -- to consult
  (202489, 'مَعدَنی', 'B1', 'B2'), -- minerals
  (202491, 'مَقطَع', 'B1', 'B2'), -- level (education) / section
  (202495, 'مَوادِ شیمیایی', 'B1', 'B2'), -- chemical substances
  (202496, 'مَوادِغِذایی', 'B1', 'C1'), -- foodstuffs
  (202497, 'مَوادِّ مُذاب', 'B1', 'C1'), -- molten materials / lava
  (202498, 'مُبلِمان', 'B1', 'B2'), -- furniture
  (202499, 'مُبلِه', 'B1', 'B2'), -- furnished
  (202502, 'مُتَمِّم', 'B1', 'B2'), -- complement
  (202505, 'مُجاوِر', 'B1', 'B2'), -- adjacent / neighboring
  (202506, 'مُجَلَّل', 'B1', 'B2'), -- luxurious
  (202507, 'مُحافِظَت', 'B1', 'A2'), -- protection
  (202510, 'مُحتَوا', 'B1', 'C1'), -- content
  (202511, 'مُخاطَب', 'B1', 'B2'), -- audience
  (202515, 'مُدَّت', 'B1', 'A2'), -- period
  (202517, 'مُراجَعِه', 'B1', 'B2'), -- referral / consultation
  (202518, 'مُراجِعه', 'B1', 'B2'), -- reference
  (202519, 'مُراجِعه‌کَردَن', 'B1', 'B2'), -- to refer
  (202525, 'مُسافَرتی', 'B1', 'B2'), -- travel (adj)
  (202526, 'مُستَأجِر', 'B1', 'B2'), -- tenant
  (202532, 'مُشاوِرِ اَملاک', 'B1', 'B2'), -- estate agent
  (202538, 'مُعتَبَر', 'B1', 'B2'), -- reliable / prestigious
  (202539, 'مُعتَقِد بودَن', 'B1', 'B2'), -- to believe
  (202540, 'مُعتَقِدبودَن', 'B1', 'B2'), -- to have belief
  (202543, 'مُقَوّا', 'B1', 'C1'), -- cardboard
  (202545, 'مُنتَظِر', 'B1', 'A2'), -- waiting
  (202549, 'مُنصَرِف شُدَن', 'B1', 'B2'), -- to give up / to change one's mind
  (202551, 'مُهاجِر', 'B1', 'B2'), -- immigrant
  (202553, 'مُهاجِرَت کَردَن', 'B1', 'B2'), -- to immigrate / to migrate
  (202554, 'مُهاجِرَت‌کَردَن', 'B1', 'B2'), -- to immigrate
  (202562, 'مُوَفَّق', 'B1', 'A2'), -- successful
  (202563, 'مِسی', 'B1', 'B2'), -- copper (adj)
  (202564, 'مِعیار', 'B1', 'B2'), -- standard / criterion
  (202565, 'مِقیاس', 'B1', 'B2'), -- scale
  (202567, 'مِهرَبانی', 'B1', 'B2'), -- kindness
  (202570, 'نامُعتَبَر', 'B1', 'C1'), -- unreliable / invalid
  (202571, 'نامگُذاری کَردَن', 'B1', 'B2'), -- to name / to give a name
  (202575, 'نوبِل', 'B1', 'B2'), -- Nobel
  (202579, 'نَثر', 'B1', 'C1'), -- prose
  (202580, 'نَجات‌دادَن', 'B1', 'A2'), -- to rescue
  (202581, 'نَخُستین', 'B1', 'B2'), -- first / primary
  (202582, 'نَزدیکان', 'B1', 'B2'), -- relatives
  (202584, 'نَظَردادَن', 'B1', 'A2'), -- to comment
  (202586, 'نَقدی', 'B1', 'B2'), -- cash
  (202587, 'نَقّاله', 'B1', 'C1'), -- conveyor
  (202589, 'نَمایِندِگی', 'B1', 'B2'), -- representative/commission
  (202591, 'نُوجَوان', 'B1', 'B2'), -- teen
  (202593, 'نُکات', 'B1', 'B2'), -- points
  (202598, 'هَدَف', 'B1', 'A2'), -- target
  (202599, 'هَرکُدام', 'B1', 'B2'), -- each
  (202601, 'هَم ... هَم ...', 'B1', 'A2'), -- ... both ... and
  (202605, 'هَمسِن', 'B1', 'B2'), -- same age
  (202607, 'هَم‌مَعنی', 'B1', 'C1'), -- synonym
  (202608, 'هَنگامی‌که', 'B1', 'B2'), -- when
  (202610, 'هَیَجان‌زَده', 'B1', 'B2'), -- excited
  (202613, 'واریز', 'B1', 'B2'), -- deposit
  (202614, 'واقِعی', 'B1', 'A2'), -- real
  (202615, 'واژه', 'B1', 'B2'), -- word
  (202616, 'واژگون کَردَن', 'B1', 'C1'), -- to turn upside down / to overturn
  (202624, 'ویتامین', 'B1', 'B2'), -- vitamin
  (202625, 'ویولُن‌زَدَن', 'B1', 'B2'), -- to play violin
  (202626, 'پاراگراف', 'B1', 'B2'), -- paragraph
  (202631, 'پولِ توجیبی', 'B1', 'C1'), -- pocket money
  (202632, 'پولِ پیش', 'B1', 'A2'), -- deposit
  (202633, 'پَرانتِز', 'B1', 'C1'), -- brackets
  (202637, 'پَرگار', 'B1', 'C1'), -- compasses
  (202638, 'پَسوَند', 'B1', 'C1'), -- suffix
  (202639, 'پَنچَر شُدَن', 'B1', 'B2'), -- To have a puncture/flat
  (202644, 'پُرسِش واژه', 'B1', 'B2'), -- question word
  (202645, 'پُرسِشی', 'B1', 'C1'), -- interrogative
  (202649, 'پِیوَست', 'B1', 'B2'), -- attachment
  (202650, 'پِیوَستِه', 'B1', 'B2'), -- continuously
  (202652, 'پیام‌رَسان', 'B1', 'C1'), -- messenger
  (202653, 'پیداشُدَن', 'B1', 'A2'), -- to be found
  (202654, 'پیش رَفتَن', 'B1', 'A2'), -- to progress
  (202658, 'پیگیری کَردَن', 'B1', 'B2'), -- to follow up
  (202660, 'چاپی', 'B1', 'B2'), -- printed
  (202661, 'چَتربازی', 'B1', 'C1'), -- parachuting
  (202662, 'چَرب', 'B1', 'B2'), -- fatty/greasy
  (202664, 'چَسباندَن', 'B1', 'C1'), -- to stick on
  (202667, 'چَندروزه', 'B1', 'C1'), -- how long/for how many days
  (202670, 'چِشمگیر', 'B1', 'B2'), -- significant / notable
  (202671, 'ژانر', 'B1', 'B2'), -- genre
  (202672, 'کاربَری', 'B1', 'B2'), -- use
  (202674, 'کاردانی', 'B1', 'C1'), -- associate's degree
  (202675, 'کارشِناسی', 'B1', 'B2'), -- B.A. / bachelor's degree
  (202679, 'کوهِستانی', 'B1', 'B2'), -- Mountainous/highland
  (202687, 'کَویر', 'B1', 'B2'), -- desert
  (202688, 'کَویری', 'B1', 'C1'), -- desert (adj)
  (202693, 'کِتابفُروش', 'B1', 'C1'), -- book seller
  (202698, 'کِنارگُذاشتَن', 'B1', 'A2'), -- to put aside
  (202702, 'گوناگون', 'B1', 'B2'), -- various
  (202703, 'گَرایِش', 'B1', 'B2'), -- tendency / inclination
  (202704, 'گَرد و خاک', 'B1', 'B2'), -- dust
  (202705, 'گَردِشگَر', 'B1', 'C1'), -- tourist
  (202708, 'گَچ', 'B1', 'B2'), -- plaster
  (202710, 'گُزارِشگَر', 'B1', 'B2'), -- reporter
  (202712, 'گُشودِه', 'B1', 'B2'), -- open / frank
  (202714, 'گِرافیکی', 'B1', 'B2'), -- graphic
  (202715, 'گِران‌بَها', 'B1', 'B2'), -- precious / valuable
  (202720, 'یِکباره', 'B1', 'B2'), -- at once/suddenly
  (202725, 'آمار', 'B2', 'C1'), -- statistics
  (202726, 'آمُوختَن', 'B2', 'C1'), -- to learn
  (202728, 'آهَنگساز', 'B2', 'C1'), -- composer
  (202729, 'آویزان', 'B2', 'C1'), -- hanging
  (202730, 'آگاه', 'B2', 'C1'), -- informed / aware
  (202731, 'ابزار', 'B2', 'C1'), -- tool / utensil
  (202732, 'اتِّصالی کَردَن', 'B2', 'C1'), -- short circuit
  (202735, 'اثرات', 'B2', 'C1'), -- effects
  (202736, 'اجتِماع', 'B2', 'C1'), -- community
  (202737, 'اجزاء', 'B2', 'C1'), -- components
  (202740, 'اختِراع', 'B2', 'C1'), -- invention
  (202744, 'ارزِشمند', 'B2', 'C1'), -- valuable
  (202745, 'اشیاء', 'B2', 'C1'), -- things / objects
  (202746, 'اطرافیان', 'B2', 'C1'), -- acquaintances / those around
  (202748, 'اظهارِ نَظَر', 'B2', 'C1'), -- comment / expression of opinion
  (202753, 'افتِتاح', 'B2', 'C1'), -- opening / inauguration
  (202755, 'افزایِش یافتَن', 'B2', 'C1'), -- to get increased
  (202756, 'افزودَن', 'B2', 'C1'), -- to add
  (202757, 'افسُردِگی', 'B2', 'C1'), -- depression
  (202758, 'اقامَت داشتَن', 'B2', 'C1'), -- to stay / reside
  (202759, 'اقتِصادی', 'B2', 'C1'), -- economic
  (202760, 'اَرگ', 'B2', 'C1'), -- citadel
  (202762, 'اَز طَرَفی', 'B2', 'C1'), -- on one hand
  (202763, 'اُستُوا', 'B2', 'C1'), -- equator
  (202764, 'اُفتِ فِشارِ خون', 'B2', 'C1'), -- low blood pressure
  (202765, 'اِستِثنا', 'B2', 'C1'), -- exception
  (202767, 'اِستِرِس زا', 'B2', 'C1'), -- stressful
  (202768, 'اِستِفراغ', 'B2', 'C1'), -- vomit
  (202769, 'ایراد', 'B2', 'C1'), -- drawback
  (202770, 'ایزوتوپ', 'B2', 'C1'), -- isotope
  (202771, 'ایفا کَردَن', 'B2', 'C1'), -- to play (a role)
  (202773, 'بااَنگیزی', 'B2', 'C1'), -- motivated
  (202774, 'باریکه', 'B2', 'C1'), -- beam (of water/light)
  (202775, 'بازارگانی', 'B2', 'C1'), -- commercial/trade
  (202776, 'بازاریاب', 'B2', 'C2'), -- the marketer
  (202777, 'به‌این‌تَرتیب', 'B2', 'C1'), -- therefore
  (202778, 'به‌تأخیر اَنداختَن', 'B2', 'C1'), -- to delay
  (202779, 'به‌تَدریج', 'B2', 'C1'), -- gradually
  (202781, 'به‌شِدَّت', 'B2', 'C2'), -- strongly/sharply
  (202782, 'به‌مَحضی اینکه‌', 'B2', 'C2'), -- immediately
  (202783, 'بودجه', 'B2', 'C1'), -- budget
  (202785, 'بَدبین', 'B2', 'C1'), -- pessimist
  (202786, 'بَدَنه', 'B2', 'C1'), -- body (structure)
  (202787, 'بَدیهی', 'B2', 'C1'), -- obvious
  (202790, 'بَرزَبان آمَدَن', 'B2', 'C1'), -- To be said
  (202791, 'بَرعُهده داشتَن', 'B2', 'C1'), -- to be responsible for
  (202792, 'بَرپایی', 'B2', 'C1'), -- establishment
  (202793, 'بَرگزاری', 'B2', 'C1'), -- holding (an event)
  (202794, 'بَرگُزیده', 'B2', 'C1'), -- selected
  (202796, 'بُحران', 'B2', 'C1'), -- crisis
  (202797, 'بُرونگَرا', 'B2', 'C2'), -- extroverted
  (202798, 'بُزُرگسالی', 'B2', 'C1'), -- adulthood
  (202799, 'بُلوغ', 'B2', 'C1'), -- maturity
  (202800, 'بِهبود', 'B2', 'C1'), -- improvement
  (202801, 'بِکر', 'B2', 'C1'), -- pristine
  (202802, 'بِینُ‌المِلَلی', 'B2', 'C2'), -- international
  (202803, 'بی‌اَنگیزه', 'B2', 'C1'), -- unmotivated
  (202804, 'تأثیرات', 'B2', 'C1'), -- effects
  (202806, 'تأسیس', 'B2', 'C1'), -- establishment
  (202807, 'تأسیس کَردَن', 'B2', 'C1'), -- to establish
  (202808, 'تاریخچه', 'B2', 'C1'), -- history
  (202809, 'تازه کَشف‌شُده', 'B2', 'C1'), -- newly discovered
  (202810, 'تازه‌دَم', 'B2', 'C1'), -- fresh (tea)
  (202811, 'تولیدات', 'B2', 'C1'), -- products
  (202812, 'تولیدِ مِثل', 'B2', 'C1'), -- reproduction
  (202813, 'توهین‌آمیز', 'B2', 'C1'), -- offensive
  (202814, 'تَأَمُّل', 'B2', 'C1'), -- contemplation
  (202815, 'تَبلیغاتی', 'B2', 'C1'), -- propaganda/advertising
  (202819, 'تَحَرُّک', 'B2', 'C1'), -- mobility
  (202821, 'تَراکُنِش', 'B2', 'C1'), -- transaction
  (202822, 'تَربیَت', 'B2', 'C1'), -- upbringing
  (202823, 'تَرفَند', 'B2', 'C1'), -- trick
  (202824, 'تَزئین شُدَن', 'B2', 'C1'), -- to get decorated
  (202828, 'تَعَلُّق داشتَن', 'B2', 'C1'), -- to belong
  (202829, 'تَغذیه', 'B2', 'C1'), -- nutrition
  (202830, 'تَغییرات', 'B2', 'C1'), -- changes
  (202831, 'تَقاضا کَردَن', 'B2', 'C1'), -- to request
  (202832, 'تَقریبی', 'B2', 'C1'), -- approximate
  (202833, 'تَقسیم نَشُدَنی', 'B2', 'C1'), -- indivisible
  (202834, 'تَقویَت', 'B2', 'C1'), -- reinforcement
  (202836, 'تَمایل', 'B2', 'C1'), -- desire
  (202837, 'تَمدید', 'B2', 'C1'), -- extension
  (202838, 'تَمدید کَردَن', 'B2', 'C1'), -- to extend
  (202839, 'تَنَفُّس', 'B2', 'C1'), -- breathing
  (202840, 'تَهَوُّع', 'B2', 'C1'), -- nausea
  (202841, 'تَوازُن', 'B2', 'C1'), -- balance
  (202842, 'تَوَجُّه کَسی را جَلب کَردَن', 'B2', 'C1'), -- to attract
  (202843, 'تَوَقُّع داشتَن', 'B2', 'C1'), -- to expect
  (202844, 'تَپِش', 'B2', 'C1'), -- beat (heart)
  (202845, 'تَک‌واحِدی', 'B2', 'C1'), -- single (unit)
  (202846, 'تِجاری', 'B2', 'C1'), -- commercial
  (202847, 'تِلِگراف', 'B2', 'C1'), -- telegraph
  (202848, 'جاذِبه', 'B2', 'C1'), -- gravitation
  (202849, 'جانداران', 'B2', 'C1'), -- livings
  (202850, 'جان‌بِه‌جان‌آفَرین‌تَسلیم‌کَردَن', 'B2', 'C1'), -- to die / to give up the ghost
  (202851, 'جویدَن', 'B2', 'C1'), -- to chew
  (202852, 'جَرایِم', 'B2', 'C1'), -- crimes
  (202853, 'جَعلی', 'B2', 'C1'), -- fake
  (202854, 'جَمعاً', 'B2', 'C1'), -- in total
  (202855, 'جَمع‌بَندی', 'B2', 'C1'), -- conclusion
  (202856, 'جَنگَل‌بان', 'B2', 'C1'), -- forester
  (202857, 'جَنگَل‌بانی', 'B2', 'C1'), -- forestry
  (202858, 'جَنین', 'B2', 'C1'), -- fetus
  (202861, 'جُداسازی', 'B2', 'C1'), -- isolation
  (202862, 'جُدایی‌ناپَذیر', 'B2', 'C1'), -- inseparable
  (202864, 'جِراحَت', 'B2', 'C1'), -- injury
  (202866, 'جِنسیَّتی', 'B2', 'C1'), -- gender (adj)
  (202867, 'حاویِ ... بودَن', 'B2', 'C1'), -- to contain
  (202868, 'حوزه', 'B2', 'C1'), -- field
  (202869, 'حَرارَت', 'B2', 'C1'), -- heat
  (202870, 'حَرفِ رَبط', 'B2', 'C1'), -- conjunction
  (202873, 'حِسابداری', 'B2', 'C1'), -- accounting
  (202875, 'حِکایَت', 'B2', 'C1'), -- anecdote/story
  (202876, 'خاتَم', 'B2', 'C2'), -- inlay
  (202877, 'خودخواه', 'B2', 'C1'), -- selfish
  (202878, 'خودشیفتِگی', 'B2', 'C1'), -- narcissism
  (202879, 'خودپَسَند', 'B2', 'C1'), -- selfish
  (202881, 'خَلق کَردَن', 'B2', 'C1'), -- to create
  (202882, 'خَواص', 'B2', 'C1'), -- benefits
  (202884, 'خُشکسالی', 'B2', 'C1'), -- drought
  (202886, 'دانِشگاهی', 'B2', 'C1'), -- academic
  (202887, 'دَر اختیار گُذاشتَن', 'B2', 'C1'), -- provide
  (202888, 'دَر اَثَرِ', 'B2', 'C1'), -- because of/by/due to
  (202889, 'دَر این مَواقِع', 'B2', 'C1'), -- in such times
  (202890, 'دَر حالی که', 'B2', 'C1'), -- while
  (202891, 'دَر دَسترَس قَرار گِرِفتَن', 'B2', 'C1'), -- to become available
  (202892, 'دَر مَجموع', 'B2', 'C1'), -- overall
  (202894, 'دَر نِهایَت', 'B2', 'C1'), -- eventually
  (202895, 'دَر واقیعیَّت', 'B2', 'C1'), -- in fact
  (202896, 'دَرونگَرا', 'B2', 'C2'), -- introverted
  (202898, 'دَرگاه', 'B2', 'C1'), -- port
  (202900, 'دَستباف', 'B2', 'C2'), -- handmade/handwoven
  (202901, 'دَستبُرد', 'B2', 'C1'), -- robbery
  (202902, 'دَسته‌بَندی', 'B2', 'C1'), -- classify/categorize
  (202903, 'دَستورُالعَمَل', 'B2', 'C1'), -- instruction
  (202905, 'دَستگیری', 'B2', 'C1'), -- getting arrested
  (202907, 'دَم‌کَرده', 'B2', 'C1'), -- made/brewed
  (202909, 'دِلخواه', 'B2', 'C1'), -- desired
  (202910, 'ذاتاً', 'B2', 'C1'), -- inherently/innately
  (202911, 'ذوب شُدَن', 'B2', 'C1'), -- to melt
  (202912, 'رادیولوژی', 'B2', 'C1'), -- radiology
  (202913, 'راهِ‌شیری', 'B2', 'C1'), -- milky way
  (202914, 'رویداد', 'B2', 'C1'), -- event
  (202915, 'روی‌هَم‌رَفته', 'B2', 'C2'), -- in total
  (202916, 'رَواج داشتَن', 'B2', 'C1'), -- to be current/prevalent
  (202918, 'رَوانپِزِشکان', 'B2', 'C2'), -- psychiatrists
  (202921, 'رُسوم', 'B2', 'C1'), -- customs
  (202922, 'رِضایَت', 'B2', 'C1'), -- satisfaction
  (202923, 'رِعایَت', 'B2', 'C1'), -- Respecting/considering
  (202924, 'رِفاه', 'B2', 'C1'), -- welfare/well-being
  (202925, 'رِوایَت', 'B2', 'C1'), -- story/narration
  (202926, 'ریوی', 'B2', 'C1'), -- pulmonary
  (202927, 'زادگاه', 'B2', 'C1'), -- birth place
  (202928, 'زاغ', 'B2', 'C1'), -- crow/magpie
  (202929, 'زودرَنج', 'B2', 'C2'), -- tetchy
  (202930, 'زَمانبَر', 'B2', 'C2'), -- time-consuming
  (202931, 'زَوایا', 'B2', 'C1'), -- angles
  (202932, 'زیست', 'B2', 'C1'), -- environment
  (202933, 'ساختار', 'B2', 'C1'), -- structure
  (202934, 'سارِق', 'B2', 'C1'), -- robber
  (202935, 'سازماندِهی', 'B2', 'C1'), -- organizing
  (202936, 'سازگاری', 'B2', 'C1'), -- compatibility
  (202937, 'ساسانیان', 'B2', 'C1'), -- Sasanians
  (202938, 'ساماندهی', 'B2', 'C2'), -- managing
  (202939, 'سانسور', 'B2', 'C1'), -- censorship
  (202941, 'سَد', 'B2', 'C1'), -- dam
  (202942, 'سَرتاسَر', 'B2', 'C1'), -- all over
  (202943, 'سَردَسته', 'B2', 'C1'), -- leader/head
  (202945, 'سَرمَقاله', 'B2', 'C1'), -- editorial/leading article
  (202946, 'سَرنَخ', 'B2', 'C1'), -- clue
  (202948, 'سَطحی', 'B2', 'C1'), -- shallow/superficial
  (202949, 'سُتونِ فَقَرات', 'B2', 'C1'), -- backbone
  (202950, 'سُخَن', 'B2', 'C1'), -- speech
  (202951, 'سُرودَن', 'B2', 'C1'), -- to write a poem
  (202952, 'سُفال', 'B2', 'C1'), -- ceramic
  (202953, 'سُفالگَری', 'B2', 'C1'), -- pottery
  (202954, 'سُمباده', 'B2', 'C2'), -- sandpaper
  (202956, 'سِپَری‌کَردَن', 'B2', 'C1'), -- to spend (time)
  (202957, 'سِکانس', 'B2', 'C1'), -- sequence
  (202959, 'شازده', 'B2', 'C1'), -- prince
  (202960, 'شاه‌ماهی', 'B2', 'C1'), -- red mullet
  (202961, 'شایِستِگی', 'B2', 'C1'), -- eligibility
  (202962, 'شورَوی', 'B2', 'C1'), -- soviet union
  (202963, 'شَخصیَّت‌پردازی', 'B2', 'C1'), -- characterization
  (202964, 'شَر و شور', 'B2', 'C1'), -- fervor/passion
  (202965, 'شَرطی', 'B2', 'C1'), -- conditional
  (202966, 'شَرق‌شِناسی', 'B2', 'C1'), -- orientalism
  (202967, 'شَهرنِشینی', 'B2', 'C2'), -- urbanism
  (202968, 'شُجاعانه', 'B2', 'C1'), -- bravely
  (202969, 'شُماره‌گُذاری', 'B2', 'C2'), -- to number
  (202970, 'شِبه‌قاره', 'B2', 'C1'), -- subcontinent
  (202971, 'شِدَّت‌گِرِفتَن', 'B2', 'C1'), -- to get heavier
  (202973, 'شِکایَت‌داشتَن', 'B2', 'C1'), -- to complain
  (202974, 'شِکل‌گیری', 'B2', 'C2'), -- formation
  (202975, 'شِگِرد', 'B2', 'C1'), -- tactic/trick
  (202977, 'صوفی', 'B2', 'C1'), -- Sufi
  (202978, 'صَدابَردار', 'B2', 'C2'), -- sound recordist
  (202979, 'صَنعَت', 'B2', 'C1'), -- industry
  (202980, 'صَنعَتی', 'B2', 'C1'), -- industrial
  (202981, 'صِداپیشه', 'B2', 'C2'), -- voice actor
  (202982, 'صِرفاً', 'B2', 'C1'), -- only
  (202983, 'ضَرَبَان', 'B2', 'C1'), -- beating (pulse)
  (202984, 'ضَمانَت', 'B2', 'C1'), -- guarantee
  (202985, 'ضَمایِر', 'B2', 'C2'), -- pronouns
  (202986, 'ضِدِّعُفونی', 'B2', 'C1'), -- to disinfect
  (202989, 'طُغیان', 'B2', 'C1'), -- rebellion / flood
  (202990, 'عالَم', 'B2', 'C1'), -- universe
  (202991, 'عامِل', 'B2', 'C1'), -- factor
  (202992, 'عَروسَک‌گَردان', 'B2', 'C1'), -- puppeteer
  (202993, 'عَقایِد', 'B2', 'C1'), -- beliefs
  (202994, 'عَلائِم', 'B2', 'C1'), -- symptoms
  (202995, 'عَلّامِه', 'B2', 'C2'), -- great scholar
  (202998, 'عَواطِف', 'B2', 'C1'), -- emotions
  (202999, 'عَوامِل', 'B2', 'C1'), -- factors
  (203000, 'عُفونَت', 'B2', 'C1'), -- infection
  (203001, 'عُمده', 'B2', 'C1'), -- main
  (203002, 'عِبرَت‌آموز', 'B2', 'C1'), -- exemplary
  (203003, 'غافِل', 'B2', 'C1'), -- unaware/inattentive
  (203004, 'غِیرِمُنتَظِره', 'B2', 'C1'), -- unexpected
  (203005, 'فارِغُ‌التَّحصیل', 'B2', 'C2'), -- graduate
  (203006, 'فوقُ‌العاده', 'B2', 'C1'), -- wonderful/extraordinary
  (203007, 'فَرآیَند', 'B2', 'C1'), -- process
  (203008, 'فَراوان', 'B2', 'C1'), -- many/abundant
  (203010, 'فَریب‌خوردَن', 'B2', 'C1'), -- to be deceived
  (203011, 'فَریب‌دادَن', 'B2', 'C1'), -- to deceive
  (203012, 'فِساد', 'B2', 'C1'), -- corruption
  (203013, 'فَقر', 'B2', 'C1'), -- poverty
  (203014, 'فَواید', 'B2', 'C1'), -- benefits
  (203015, 'فیشینگ', 'B2', 'C2'), -- phishing
  (203016, 'فیلمنامه', 'B2', 'C1'), -- screenplay
  (203017, 'فیوز', 'B2', 'C1'), -- fuse
  (203020, 'قاعِده', 'B2', 'C1'), -- rule
  (203021, 'قالِب', 'B2', 'C1'), -- block/mold
  (203022, 'قاچاقچی', 'B2', 'C1'), -- smuggler
  (203023, 'قَمَری', 'B2', 'C1'), -- lunar
  (203024, 'قُرونِ وُسطی', 'B2', 'C1'), -- the middle ages
  (203025, 'قُومی', 'B2', 'C1'), -- ethnic
  (203026, 'قِدمَت', 'B2', 'C1'), -- oldness/dating
  (203027, 'قِید', 'B2', 'C1'), -- adverb
  (203028, 'لاغَراَندام', 'B2', 'C2'), -- thin
  (203029, 'لُعاب', 'B2', 'C1'), -- glazing
  (203030, 'لُعابدار', 'B2', 'C1'), -- glazed
  (203032, 'مالباخته', 'B2', 'C1'), -- robbed
  (203034, 'موجِب‌شُدَن', 'B2', 'C1'), -- to cause
  (203035, 'مورِدِنَظَر', 'B2', 'C1'), -- Intended/appropriate
  (203036, 'موضوعات', 'B2', 'C1'), -- subjects/matters
  (203037, 'مَبنا', 'B2', 'C2'), -- basis
  (203038, 'مَجهول', 'B2', 'C1'), -- passive/unknown
  (203039, 'مَحدودیَّت', 'B2', 'C1'), -- restriction
  (203040, 'مَحسوب‌شُدَن', 'B2', 'C1'), -- to be considered
  (203041, 'مَخارِج', 'B2', 'C1'), -- expenses
  (203042, 'مَراحِل', 'B2', 'C1'), -- steps
  (203043, 'مَراکِز', 'B2', 'C1'), -- centers
  (203044, 'مَرجَع', 'B2', 'C1'), -- reference
  (203045, 'مَسئولیَّت‌پَذیر', 'B2', 'C2'), -- responsible
  (203047, 'مَسدودکَردَن', 'B2', 'C1'), -- to block
  (203048, 'مَسمومیَّت', 'B2', 'C1'), -- poisoning
  (203049, 'مَشاغِل', 'B2', 'C1'), -- occupations/jobs
  (203050, 'مَطالِب', 'B2', 'C1'), -- contents
  (203051, 'مَطلوب', 'B2', 'C1'), -- favourable
  (203052, 'مَغرورانه', 'B2', 'C1'), -- proudly
  (203053, 'مَفهومی', 'B2', 'C1'), -- conceptual
  (203055, 'مَنافِع', 'B2', 'C1'), -- interests
  (203056, 'مَنع‌کَردَن', 'B2', 'C1'), -- to prohibit
  (203057, 'مَکتوب', 'B2', 'C1'), -- written
  (203058, 'مَکتَب', 'B2', 'C1'), -- school
  (203059, 'مُؤَسَّسه', 'B2', 'C1'), -- institute
  (203060, 'مُبتَلاشُدَن', 'B2', 'C1'), -- to be infected
  (203061, 'مُتون', 'B2', 'C1'), -- texts
  (203062, 'مُتَعَدِّد', 'B2', 'C1'), -- numerous
  (203063, 'مُتَفَکِّر', 'B2', 'C1'), -- thoughtful
  (203064, 'مُتَقاطِع', 'B2', 'C1'), -- cross
  (203067, 'مُجَزّا', 'B2', 'C1'), -- separately/distinct
  (203068, 'مُحتَوایی', 'B2', 'C2'), -- content (adj)
  (203069, 'مُداوِم', 'B2', 'C1'), -- constantly
  (203070, 'مُذاکِرات', 'B2', 'C1'), -- negotiations
  (203071, 'مُراقِبه', 'B2', 'C1'), -- meditation
  (203072, 'مُرَخَّص‌شُدَن', 'B2', 'C1'), -- to release
  (203073, 'مُرَکَّب', 'B2', 'C1'), -- compound
  (203074, 'مُستَقِل', 'B2', 'C1'), -- independent
  (203075, 'مُسَلَّط', 'B2', 'C1'), -- dominant
  (203076, 'مُسَلَّط‌بودَن به خود', 'B2', 'C1'), -- self-control
  (203077, 'مُشت‌کوبیدَن', 'B2', 'C1'), -- to beat
  (203078, 'مُطابَقَت', 'B2', 'C1'), -- conformity
  (203079, 'مُطابِقِ با', 'B2', 'C1'), -- correspond to
  (203080, 'مُطلَق', 'B2', 'C1'), -- absolute
  (203081, 'مُعاصِر', 'B2', 'C1'), -- contemporary
  (203082, 'مُقابِله', 'B2', 'C1'), -- dealing with
  (203083, 'مُقَدَّمه', 'B2', 'C1'), -- introduction
  (203084, 'مُنتَقِد', 'B2', 'C1'), -- reviewer/critic
  (203085, 'مُنجَرشُدَن', 'B2', 'C1'), -- to result in
  (203087, 'مُهره', 'B2', 'C1'), -- vertebra
  (203088, 'مُواجهه', 'B2', 'C1'), -- confrontation
  (203089, 'مُوسِمی', 'B2', 'C1'), -- seasonal
  (203090, 'مُکَمِّل', 'B2', 'C1'), -- supplement/complement
  (203091, 'مِحوَر', 'B2', 'C1'), -- axis
  (203092, 'مِلَل', 'B2', 'C1'), -- nations
  (203093, 'نااَمنی', 'B2', 'C1'), -- insecurity
  (203094, 'ناخواسته', 'B2', 'C1'), -- unwanted/undesirable
  (203095, 'نامَطلوب', 'B2', 'C2'), -- undesirable
  (203096, 'نام‌گُذاری', 'B2', 'C1'), -- naming
  (203097, 'نانو', 'B2', 'C1'), -- nano
  (203098, 'نانوتِکنولوژیست', 'B2', 'C1'), -- nanotechnologist
  (203099, 'نانومِتری', 'B2', 'C1'), -- nanometric
  (203100, 'نانویی', 'B2', 'C2'), -- nano-scale
  (203101, 'ناپَسَند', 'B2', 'C1'), -- indecent
  (203103, 'نَتایِج', 'B2', 'C1'), -- consequences
  (203104, 'نَتیجه‌گیری', 'B2', 'C1'), -- conclusion
  (203106, 'نَمایِشنامه', 'B2', 'C1'), -- the play
  (203107, 'نَهاد', 'B2', 'C1'), -- unit/institution
  (203108, 'نَواحی', 'B2', 'C1'), -- areas
  (203109, 'نُوساز', 'B2', 'C2'), -- recently built/new-built
  (203111, 'نِشَست', 'B2', 'C1'), -- leakage/session
  (203112, 'نِظام', 'B2', 'C1'), -- system
  (203114, 'هوشیاری', 'B2', 'C1'), -- consciousness
  (203115, 'هَماهَنگی', 'B2', 'C1'), -- coordination
  (203116, 'هَمزَمان', 'B2', 'C1'), -- simultaneously
  (203117, 'هَمچون', 'B2', 'C1'), -- like
  (203118, 'هَک‌کَردَن', 'B2', 'C1'), -- to hack
  (203119, 'هِجری', 'B2', 'C1'), -- ah/hegira
  (203120, 'وارِدِعَمَل‌شُدَن', 'B2', 'C2'), -- to take an action
  (203121, 'واژه‌سازی', 'B2', 'C1'), -- word formation
  (203123, 'وَجه (نَقد)', 'B2', 'C1'), -- cash
  (203124, 'وَرَم‌کَردَن', 'B2', 'C1'), -- to swell
  (203125, 'وَسوَسِه‌کُنَنده', 'B2', 'C1'), -- tempting
  (203126, 'وَسَطِا', 'B2', 'C1'), -- middle ages
  (203127, 'وَسیع', 'B2', 'C1'), -- vast
  (203128, 'وَظایِف', 'B2', 'C1'), -- duties
  (203129, 'وَقایِع', 'B2', 'C1'), -- events
  (203130, 'وُجوه', 'B2', 'C1'), -- aspects
  (203131, 'پابَرجا', 'B2', 'C1'), -- established
  (203132, 'پانسمان', 'B2', 'C1'), -- wound dressing/bandage
  (203133, 'پانسمان کَردَن', 'B2', 'C1'), -- to bandage
  (203134, 'پایانه', 'B2', 'C1'), -- ending / terminal
  (203135, 'پوستِ دَرَخت', 'B2', 'C1'), -- tree bark
  (203136, 'پوکیِ اُستُخوان', 'B2', 'C2'), -- osteoporosis
  (203137, 'پَدیده', 'B2', 'C1'), -- phenomenon
  (203138, 'پَرتَوان', 'B2', 'C2'), -- powerful
  (203139, 'پَروَرِش', 'B2', 'C1'), -- cultivation
  (203140, 'پَریشان', 'B2', 'C1'), -- afflicted
  (203141, 'پَسَندیده', 'B2', 'C1'), -- desirable
  (203142, 'پَس‌اَنداز', 'B2', 'C2'), -- saving
  (203143, 'پَناه بُردَن', 'B2', 'C1'), -- to take shelter
  (203144, 'پُر دَرآمَد', 'B2', 'C1'), -- high-paying
  (203145, 'پُرشوری', 'B2', 'C2'), -- passionate
  (203146, 'پُشتکار', 'B2', 'C1'), -- perseverance
  (203147, 'پِیوَسته', 'B2', 'C1'), -- constantly
  (203148, 'پیدایِش', 'B2', 'C1'), -- genesis/emergence
  (203150, 'چَندبَرابَر', 'B2', 'C2'), -- multiple
  (203151, 'چَندواحِدی', 'B2', 'C1'), -- multi-apartment
  (203152, 'کارآمَد', 'B2', 'C1'), -- efficient
  (203153, 'کارتُن‌خواب', 'B2', 'C1'), -- homeless
  (203154, 'کارشِناس', 'B2', 'C1'), -- expert
  (203155, 'کافِئین', 'B2', 'C1'), -- caffeine
  (203157, 'کاهِش‌یافتَن', 'B2', 'C1'), -- to decrease
  (203158, 'کوبیدَن (مُشت)', 'B2', 'C1'), -- to beat
  (203159, 'کوره', 'B2', 'C1'), -- furnaces
  (203160, 'کَشف‌کَردَن', 'B2', 'C1'), -- to discover
  (203161, 'کَمبود', 'B2', 'C1'), -- shortage
  (203162, 'کَم‌آبی', 'B2', 'C1'), -- drought
  (203163, 'کَم‌طاقَت', 'B2', 'C1'), -- impatient
  (203164, 'کَهکِشان', 'B2', 'C1'), -- galaxy
  (203165, 'کُرَوی', 'B2', 'C1'), -- spherical
  (203166, 'کُلاهبَردار', 'B2', 'C1'), -- fraudster/fraudulent
  (203167, 'کُلاهبَرداری', 'B2', 'C1'), -- fraud/fraudulence
  (203168, 'کُهَن', 'B2', 'C1'), -- ancient
  (203169, 'گازِ گُلخانه‌ای', 'B2', 'C2'), -- Greenhouse gas
  (203171, 'گَچ‌گِرِفتَن', 'B2', 'C1'), -- to cast
  (203172, 'گُستَرِش', 'B2', 'C1'), -- expansion
  (203174, 'گِرایِش', 'B2', 'C1'), -- attitude/tendency
  (203176, 'یِکنَواخت', 'B2', 'C1'), -- steady
  (203177, 'آسیب‌پَذیر', 'C1', 'C2'), -- vulnerable
  (203178, 'اتباع', 'C1', 'C2'), -- citizens
  (203181, 'ارتقاء دادَن', 'C1', 'C2'), -- to upgrade
  (203182, 'اعتِرافات', 'C1', 'C2'), -- confessions
  (203188, 'بَسزا', 'C1', 'C2'), -- significant
  (203190, 'تابیده', 'C1', 'C2'), -- radiated
  (203191, 'تَحَوُّلات', 'C1', 'C2'), -- changes
  (203192, 'تَرغیب کَردَن', 'C1', 'C2'), -- to persuade
  (203193, 'تَشَکُّل', 'C1', 'C2'), -- organization
  (203196, 'تَوالی', 'C1', 'C2'), -- sequence
  (203197, 'جارچی', 'C1', 'C2'), -- crier
  (203199, 'جِراحَت‌ها', 'C1', 'C2'), -- injuries
  (203201, 'حُکم‌فَرما', 'C1', 'C2'), -- dominant
  (203202, 'حِکایَت داشتَن', 'C1', 'C2'), -- to indicate
  (203203, 'خاستگاه', 'C1', 'C2'), -- origin
  (203204, 'خودبُزُرگ‌بینی', 'C1', 'C2'), -- self-importance
  (203205, 'دَر حالِ اِنقِراض', 'C1', 'C2'), -- endangered/going extinct
  (203207, 'دَرونه', 'C1', 'C2'), -- embedded
  (203208, 'رَوایی', 'C1', 'C2'), -- narrative
  (203209, 'سانسکریت', 'C1', 'C2'), -- Sanskrit
  (203210, 'سِتاره‌شِناسان', 'C1', 'C2'), -- astronomers
  (203211, 'سِتودَنی', 'C1', 'C2'), -- admirable
  (203212, 'صَنعَتگَر', 'C1', 'C2'), -- craftsman
  (203213, 'عَرصَه', 'C1', 'C2'), -- domain
  (203214, 'فَتا', 'C1', 'C2'), -- Iranian cyber police
  (203215, 'فَرتوت', 'C1', 'C2'), -- decrepit/old
  (203218, 'مَوصولی', 'C1', 'C2'), -- relative
  (203219, 'مَکاتِب', 'C1', 'C2'), -- schools
  (203220, 'مُتَمایِزکَردَن', 'C1', 'C2'), -- to differentiate
  (203221, 'مُتَمِّم', 'C1', 'C2'), -- complement
  (203222, 'مُنبَسِط', 'C1', 'C2'), -- expanded
  (203224, 'مُنحَل‌شُدَن', 'C1', 'C2'), -- to get dissolved
  (203225, 'مُنقَبِض‌شُدَن', 'C1', 'C2'), -- to contract
  (203226, 'مُنَبَّت‌کاری', 'C1', 'C2'), -- wood carving
  (203227, 'مِسگَر', 'C1', 'C2'), -- coppersmith
  (203228, 'مِغار', 'C1', 'C2'), -- chisel
  (203229, 'نُخبه', 'C1', 'C2'), -- elite
  (203230, 'ویرانگَر', 'C1', 'C2'), -- destructive
  (203231, 'پُرفَریب', 'C1', 'C2'), -- sly/tricky
  (203242, 'بَر', 'B1', 'A2'), -- on / upon (formal)
  (203252, 'داده', 'B1', 'A2'), -- data
  (203258, 'اِسلامی', 'B1', 'B2'), -- Islamic
  (203275, 'دَر حالِ', 'B1', 'A2'), -- in the process of / currently
  (203287, 'تَوسِعِه', 'B2', 'C1'), -- development / expansion
  (203292, 'گُفتِه', 'B1', 'A2'), -- statement / said (thing)
  (203293, 'دَست دادَن', 'B1', 'A2'), -- to shake hands / to lose
  (203311, 'اِسلام', 'B1', 'B2'), -- Islam
  (203314, 'غِیر', 'B1', 'A2'), -- other than / non- (prefix)
  (203320, 'اَندیشِه', 'B2', 'C1'), -- thought / idea (literary)
  (203322, 'نَمودَن', 'B2', 'C1'), -- to do / to show (formal, literary)
  (203329, 'قَرار داشتَن', 'B1', 'A2'), -- to be located
  (203343, 'فَرهَنگی', 'B1', 'B2'), -- cultural
  (203351, 'زَمانی', 'B1', 'A2'), -- temporal / at a time (when)
  (203352, 'شَهید', 'B2', 'C1'), -- martyr
  (203359, 'رَوَند', 'B2', 'C1'), -- process / trend
  (203360, 'حاکِم', 'B2', 'C1'), -- ruler
  (203367, 'مُعتَقِد', 'B2', 'C1'), -- believing / convinced
  (203373, 'اِمام', 'B2', 'C1'), -- imam (religious leader)
  (203375, 'دینی', 'B1', 'B2'), -- religious
  (203382, 'موجِب', 'B2', 'C1'), -- cause / reason
  (203386, 'واقِع', 'B1', 'A2'), -- located / actual (در واقع = in fact)
  (203388, 'شایَستَن', 'C2', 'C1'), -- to be fitting / worthy of (archaic)
  (203390, 'بی', 'B1', 'A2'), -- without- (prefix, e.g. بی‌کار = jobless)
  (203403, 'فَرار', 'B1', 'A2'), -- escape (فرار کردن = to escape)
  (203404, 'نَجات', 'B1', 'A2'), -- rescue (نجات دادن = to save)
  (203406, 'مُتِوَجِّه', 'B1', 'A2'), -- aware / noticing (متوجه شدن = to realize)
  (203407, 'عِوَض', 'B1', 'A2'), -- change / instead (عوض کردن = to change)
  (203408, 'اِعتِماد', 'B1', 'A2'), -- trust (اعتماد کردن = to trust)
  (203413, 'پُرونده', 'B1', 'A2'), -- file / case
  (203414, 'رَد', 'B1', 'A2'), -- trace (رد کردن = to reject / to pass)
  (203415, 'اَسلَحه', 'B1', 'A2'), -- weapon
  (203421, 'خَفه', 'B1', 'A2'), -- mute / quiet (خفه شو! = shut up!)
  (203422, 'قَضیه', 'B1', 'A2'), -- matter / story
  (203423, 'کُشتَن', 'B1', 'A2'), -- to kill
  (203424, 'تَرک', 'B1', 'A2'), -- departure / crack (ترک کردن = to leave / to quit)
  (203427, 'شَلیک', 'B1', 'A2'), -- gunshot (شلیک کردن = to shoot)
  (203429, 'مُبارِزه', 'B1', 'A2'), -- fight / struggle (مبارزه کردن = to struggle)
  (203430, 'قَتل', 'B1', 'A2'), -- murder
  (203432, 'مُلاقات', 'B1', 'A2'), -- meeting / visit (ملاقات کردن = to visit)
  (203434, 'بِه نَظَر', 'B1', 'A2'), -- it seems / in one's opinion
  (203438, 'زِندان', 'B1', 'A2'), -- prison
  (203440, 'اِحتیاج', 'B1', 'A2'), -- need (احتیاج داشتن = to need)
  (203441, 'نابود', 'B1', 'A2'), -- destroyed (نابود کردن = to destroy)
  (203442, 'اِفتِخار', 'B1', 'A2'), -- honor / pride (افتخار کردن = to be proud)
  (203444, 'جُک', 'B1', 'A2'), -- joke
  (203452, 'مَأمور', 'B1', 'A2'), -- agent / officer
  (203461, 'مَخفی', 'B1', 'A2'), -- hidden / secret (مخفی کردن = to hide)
  (203486, 'بَخشیدَن', 'B1', 'A2'), -- to forgive / to give
  (203492, 'یالا', 'B1', 'A2'), -- come on! / hurry up!
  (203732, 'حَرام', 'B1', 'B2'), -- forbidden (religious)
  (203898, 'زَجر', 'B2', 'C1'), -- torment / suffering (زجر کشیدن = to suffer)
  (203917, 'خارِق‌العاده', 'B2', 'C2'), -- extraordinary / miraculous
  (203924, 'توطِئه', 'B2', 'C1'), -- conspiracy / plot
  (203929, 'طَلَب', 'B2', 'C1'), -- claim / demand (formal)
  (203938, 'عَدَم', 'B2', 'C1'), -- lack / absence (formal)
  (203942, 'خاندان', 'B2', 'C1'), -- dynasty / family lineage
  (203948, 'مَحسوب', 'B2', 'C1'), -- considered / counted (محسوب شدن = to be considered)
  (203954, 'مَسموم', 'B2', 'C1'), -- poisoned (مسموم شدن = to be poisoned)
  (203958, 'قَلَمرو', 'B2', 'C1'), -- realm / territory
  (203962, 'سِکته', 'B2', 'C1'), -- stroke [medical] (سکته کردن = to have a stroke)
  (203969, 'عام', 'B2', 'C1'), -- general / public
  (203971, 'سَرگُرد', 'B2', 'C1'), -- major [military rank]
  (203983, 'مُوَکِّل', 'B2', 'C1'), -- client [legal]
  (203987, 'اِحضار', 'B2', 'C1'), -- summons (احضار کردن = to summon)
  (203995, 'مَعرَض', 'B2', 'C1'), -- exposure (در معرض = exposed to)
  (203999, 'تِرور', 'B2', 'C1'), -- assassination / terror (loanword)
  (204003, 'دادِستان', 'B2', 'C1'), -- prosecutor
  (204023, 'اِفتِضاح', 'B2', 'C1'), -- disaster / scandal
  (204044, 'پَیوَند', 'B2', 'C1'), -- connection / transplant; bond
  (204053, 'مَعشوقه', 'B2', 'C1'), -- beloved / lover
  (204056, 'دَریچه', 'B2', 'C1'), -- valve / small window
  (204075, 'اِختِلال', 'B2', 'C1'), -- disorder / disturbance
  (204085, 'زِنا', 'B2', 'C1'), -- adultery
  (204095, 'غَلَبه', 'B2', 'C1'), -- overcoming / dominance (غلبه کردن = to overcome)
  (204097, 'تَسخیر', 'B2', 'C1'), -- conquest (تسخیر کردن = to conquer)
  (204098, 'دَلّال', 'B2', 'C1'), -- broker / dealer
  (204107, 'مُطَّلِع', 'B2', 'C1'), -- aware / informed (مطلع بودن = to be aware)
  (204112, 'وَسوَسه', 'B2', 'C1'), -- temptation (وسوسه کردن = to tempt)
  (204143, 'عَفو', 'B2', 'C1'), -- pardon / amnesty (عفو کردن = to pardon)
  (204169, 'مُنحَصِر بِه فَرد', 'B1', 'B2'), -- exclusive / unique
  (204174, 'هَرج‌ومَرج', 'B2', 'C1'), -- chaos / anarchy
  (204189, 'عَکس‌العَمَل', 'B1', 'C1'), -- reaction
  (204200, 'رومی', 'B2', 'C1'), -- Roman
  (204211, 'دَربار', 'B2', 'C1'), -- royal court
  (204229, 'تَصَرُّف', 'B2', 'C1'), -- occupation / seizure (تصرف کردن = to seize)
  (204231, 'صَلاح', 'B2', 'C1'), -- advisable / proper (به صلاح بودن = to be advisable)
  (204243, 'تَکامُل', 'B2', 'C1'), -- evolution / development
  (204248, 'مُختَصات', 'B2', 'C1'), -- coordinates
  (204255, 'دارایِ', 'B2', 'C1'), -- having / possessing (formal)
  (204258, 'فِرکانس', 'B2', 'C1'), -- frequency (loanword)
  (204262, 'تَقدیر', 'B2', 'C1'), -- fate / destiny
  (204273, 'سازه', 'B2', 'C1'), -- structure (construction term)
  (204281, 'جوخه', 'B2', 'C1'), -- squad / platoon
  (204287, 'ذات', 'B2', 'C1'), -- essence / nature
  (204289, 'اِنجیل', 'B2', 'C1'), -- the Bible / Gospel
  (204293, 'جُنون', 'B2', 'C1'), -- madness / insanity
  (204304, 'اِجتِناب', 'B2', 'C1'), -- avoidance (اجتناب کردن = to avoid)
  (204318, 'غارَت', 'B2', 'C1'), -- plunder / looting (غارت کردن = to plunder)
  (204330, 'شَلّاق', 'B2', 'C1'), -- whip
  (204333, 'سَرجوخه', 'B2', 'C1'), -- corporal [military rank]
  (204334, 'باشُکوه', 'B2', 'C1'), -- magnificent
  (204336, 'بابابُزُرگ', 'A1', 'A2'), -- grandfather
  (204339, 'مُلاحَظه', 'B2', 'C1'), -- consideration (ملاحظه کردن = to consider)
  (204340, 'لَخته', 'B2', 'C1'), -- clot
  (204354, 'واگُذار', 'B2', 'C1'), -- transferred (واگذار کردن = to hand over)
  (204357, 'نَنگ', 'B2', 'C1'), -- shame / disgrace
  (204359, 'ناوگان', 'B2', 'C1'), -- fleet
  (204368, 'پاکسازی', 'B2', 'C1'), -- cleansing / purge
  (204371, 'وَقف', 'B2', 'C1'), -- endowment / dedication (وقف کردن = to dedicate)
  (204374, 'صومِعه', 'B2', 'C1'), -- monastery
  (204377, 'هَفتاد', 'A1', 'A2'), -- seventy
  (204389, 'ناشی اَز', 'B1', 'B2'), -- resulting from
  (204399, 'پارسی', 'B2', 'C1'), -- Persian (formal/archaic name for the language)
  (204405, 'اَندوه', 'B2', 'C1'), -- sorrow
  (204408, 'نارَنجَک', 'B2', 'C1'), -- grenade
  (204409, 'خَزانه', 'B2', 'C1'), -- treasury
  (204413, 'تَبرِئه', 'B2', 'C1'), -- acquittal (تبرئه کردن = to acquit)
  (204428, 'چَهارده', 'A1', 'A2'), -- fourteen
  (204440, 'گُروهان', 'B2', 'C1'), -- company [military unit]
  (204449, 'آنان', 'B2', 'C1'), -- they (formal / literary)
  (204452, 'اَهرُم', 'B2', 'C1'), -- lever
  (204457, 'غَیب', 'B2', 'C1'), -- the unseen (formal / religious; غیب شدن = to vanish)
  (204461, 'پیشگویی', 'B2', 'C1'), -- prophecy (پیشگویی کردن = to prophesy)
  (204462, 'حِراسَت', 'B2', 'C1'), -- security / protection (formal)
  (204464, 'تَصاحُب', 'B2', 'C1'), -- possession / appropriation (تصاحب کردن = to take possession of)
  (204470, 'مَقتول', 'B2', 'C1'), -- murder victim
  (204475, 'سوءاِستِفاده', 'B2', 'C1'), -- abuse / misuse (سوءاستفاده کردن = to abuse)
  (204477, 'شِتاب', 'B2', 'C1'), -- acceleration / haste
  (204484, 'مؤَثِّر', 'B1', 'B2'), -- effective
  (204494, 'اِعزام', 'B2', 'C1'), -- dispatch (اعزام کردن = to dispatch)
  (204497, 'تَبعید', 'B2', 'C1'), -- exile (تبعید کردن = to exile)
  (204499, 'لَوح', 'B2', 'C1'), -- tablet / plaque (formal)
  (204501, 'بَخیه', 'B2', 'C1'), -- stitch / suture (medical)
  (204507, 'مُعَلَّق', 'B2', 'C1'), -- suspended / floating
  (204509, 'آبنَبات', 'A1', 'A2'), -- candy
  (204512, 'تَنگه', 'B2', 'C1'), -- strait (geography)
  (204523, 'طَعنه', 'B2', 'C1'), -- sarcasm / taunt
  (204528, 'مُحال', 'B1', 'B2'), -- impossible (colloquial)
  (204530, 'گَنجینه', 'B2', 'C1'), -- treasure / treasury
  (204550, 'غُدّه', 'B2', 'C1'), -- gland
  (204555, 'تُفَنگدار', 'B2', 'C1'), -- rifleman / marine
  (204559, 'تَشَنُّج', 'B2', 'C1'), -- convulsion; tension
  (204560, 'مُؤَدَّب', 'A2', 'B1'), -- polite
  (204568, 'سِپاسگُزار', 'B1', 'B2'), -- grateful
  (204570, 'پَنجشَنبه', 'A1', 'A2'), -- Thursday
  (204580, 'توقیف', 'B2', 'C1'), -- confiscation (توقیف کردن = to confiscate)
  (204583, 'فِطرَت', 'B2', 'C1'), -- nature / instinct (formal)
  (204585, 'وَطَن', 'B1', 'B2'), -- homeland
  (204586, 'اِحاطه', 'B2', 'C1'), -- encirclement (احاطه کردن = to surround)
  (204589, 'رَخت', 'B1', 'B2'), -- clothes (formal)
  (204590, 'تَدارُکات', 'B2', 'C1'), -- provisions / logistics
  (204594, 'سَواره', 'B1', 'B2'), -- mounted / on horseback
  (204595, 'فَتح', 'B1', 'B2'), -- conquest (فتح کردن = to conquer)
  (204597, 'عِبادَت', 'B1', 'B2'), -- worship (عبادت کردن = to worship)
  (204600, 'باروت', 'B1', 'B2'), -- gunpowder
  (204601, 'سیصَد', 'A1', 'A2'), -- three hundred
  (204602, 'پوچ', 'B1', 'B2'), -- void / meaningless
  (204607, 'شُعاع', 'B1', 'B2'), -- radius; ray
  (204608, 'تَلَفُّظ', 'B1', 'B2'), -- pronunciation (تلفظ کردن = to pronounce)
  (204611, 'مُقَدَّم', 'B2', 'C1'), -- prior / preceding (formal)
  (204612, 'نُدرَت', 'B1', 'B2'), -- rarity (به‌ندرت = rarely)
  (204613, 'مُطابِق', 'B1', 'B2'), -- according to / matching
  (204619, 'هَمدَست', 'B1', 'B2'), -- accomplice
  (204620, 'مُجَهَّز', 'B1', 'B2'), -- equipped
  (204621, 'ثَبات', 'B1', 'B2'), -- stability
  (204623, 'کالبَد', 'B2', 'C1'), -- body / corpse (forensic, formal)
  (204624, 'هِفدَه', 'A1', 'A2'), -- seventeen
  (204628, 'بُمباران', 'B1', 'B2'), -- bombing (بمباران کردن = to bomb)
  (204630, 'آزادانه', 'B1', 'B2'), -- freely
  (204631, 'طَفره', 'B2', 'C1'), -- evasion (طفره رفتن = to evade)
  (204632, 'حومه', 'B1', 'B2'), -- suburb
  (204634, 'اِدغام', 'B2', 'C1'), -- merger / integration (ادغام کردن = to merge)
  (204637, 'سَرپیچی', 'B2', 'C1'), -- disobedience (سرپیچی کردن = to disobey)
  (204638, 'دَستپاچه', 'B1', 'B2'), -- flustered / confused
  (204640, 'هُجوم', 'B2', 'C1'), -- onslaught / invasion
  (204641, 'مَنتَها', 'B1', 'B2'), -- however / but (formal)
  (204642, 'ناقِص', 'B1', 'B2'), -- incomplete / defective
  (204643, 'عُقده', 'B1', 'B2'), -- complex [psychological] / grudge
  (204644, 'مَرَض', 'B1', 'B2'), -- disease (formal)
  (204645, 'عَمد', 'B1', 'B2'), -- intent (عمداً = intentionally)
  (204649, 'چَرَند', 'B1', 'B2'), -- nonsense
  (204650, 'مَتروکه', 'B2', 'C1'), -- abandoned / deserted
  (204651, 'مُنصَرِف', 'B1', 'B2'), -- dissuaded (منصرف شدن = to change one's mind)
  (204657, 'سِرشار', 'B2', 'C1'), -- overflowing / full of (formal)
  (204659, 'خواهان', 'B1', 'B2'), -- desirous / wanting (formal)
  (204661, 'مُصیبَت', 'B2', 'C1'), -- tragedy / calamity
  (204662, 'وَصیَّت', 'B2', 'C1'), -- will / testament (وصیت کردن = to bequeath)
  (204664, 'بِدرود', 'B1', 'B2'), -- farewell (formal)
  (204665, 'لایِحه', 'B2', 'C1'), -- bill [legislation]
  (204666, 'وُضوح', 'B1', 'B2'), -- clarity (به‌وضوح = clearly)
  (204670, 'مَعجون', 'B1', 'B2'), -- concoction / potion
  (204671, 'تُهمَت', 'B1', 'B2'), -- slander / false accusation
  (204672, 'مُستَحِق', 'B1', 'B2'), -- deserving / entitled
  (204675, 'خواستار', 'B1', 'B2'), -- desirous / demanding (formal)
  (204677, 'پادزَهر', 'B1', 'B2'), -- antidote
  (204679, 'رِژه', 'B1', 'B2'), -- parade / march (military)
  (204681, 'روزگار', 'B1', 'B2'), -- time / era (formal)
  (204682, 'پَروَردگار', 'B2', 'C1'), -- the Lord / God (religious formal)
  (204685, 'توبه', 'B1', 'B2'), -- repentance (توبه کردن = to repent)
  (204686, 'پروتکل', 'B1', 'B2'), -- protocol (loanword)
  (204690, 'اَنگَل', 'B1', 'B2'), -- parasite
  (204691, 'دِسامبر', 'A1', 'A2'), -- December
  (204696, 'نَوازَنده', 'B1', 'B2'), -- musician / player [instrument]
  (204697, 'عُنصُر', 'B1', 'B2'), -- element (chemistry / component)
  (204699, 'مَخمَصه', 'B2', 'C1'), -- predicament / trouble
  (204700, 'طَمَع', 'B1', 'B2'), -- greed
  (204701, 'اَرمَغان', 'B2', 'C1'), -- gift / souvenir (formal)
  (204702, 'نِعمَت', 'B1', 'B2'), -- blessing / bounty (formal)
  (204703, 'تَشریفات', 'B2', 'C1'), -- formalities / protocol
  (204705, 'فولاد', 'B1', 'B2'), -- steel
  (204707, 'اِستِخراج', 'B1', 'B2'), -- extraction (استخراج کردن = to extract)
  (204708, 'تَعظیم', 'B2', 'C1'), -- bowing (تعظیم کردن = to bow)
  (204709, 'ذِکر', 'B1', 'B2'), -- mention (formal; ذکر کردن = to mention)
  (204710, 'گُشاد', 'B1', 'B2'), -- loose / baggy
  (204711, 'دَرز', 'B1', 'B2'), -- seam / crack
  (204713, 'کَماندار', 'B1', 'B2'), -- archer
  (204715, 'بِستَر', 'B1', 'B2'), -- bed (formal); riverbed
  (204718, 'سَنگَر', 'B1', 'B2'), -- trench / bunker (military)
  (204719, 'آپریل', 'A1', 'A2'), -- April
  (204720, 'مُحتاط', 'B1', 'B2'), -- cautious
  (204723, 'نِرخ', 'B1', 'B2'), -- rate / price
  (204724, 'مَوضِع', 'B1', 'B2'), -- position / stance (formal)
  (204725, 'پیراهَن', 'A1', 'A2'), -- shirt
  (204729, 'پَسَند', 'B1', 'B2'), -- liking / approval (formal)
  (204730, 'لَشکَر', 'B2', 'C1'), -- army / legion (formal)
  (204731, 'تِقَلا', 'B1', 'B2'), -- struggle / strife (تقلا کردن = to struggle)
  (204733, 'پَراکَنده', 'B1', 'B2'), -- scattered
  (204734, 'هِجدَه', 'A1', 'A2'), -- eighteen
  (204735, 'ژِنِراتور', 'B1', 'B2'), -- generator (loanword)
  (204736, 'شِعار', 'B1', 'B2'), -- slogan
  (204737, 'پُشته', 'B1', 'B2'), -- pile / heap
  (204738, 'آذوقه', 'B1', 'B2'), -- provisions / food supply
  (204744, 'لَنگَرگاه', 'B2', 'C1'), -- harbor / anchorage
  (204746, 'صَرفه', 'B1', 'B2'), -- benefit / thrift (به‌صرفه = cost-effective)
  (204747, 'بورس', 'B1', 'B2'), -- stock exchange; scholarship (loanword)
  (204749, 'سَرپا', 'B1', 'B2'), -- standing / on one's feet
  (204751, 'ظالِم', 'B1', 'B2'), -- oppressor / tyrant
  (204752, 'صاعِقه', 'B1', 'B2'), -- lightning bolt
  (204753, 'اَشراف', 'B2', 'C1'), -- aristocracy / nobility
  (204756, 'مَحفِل', 'B2', 'C1'), -- gathering / circle (social)
  (204757, 'حافِظ', 'B1', 'B2'), -- protector / guardian (formal)
  (204758, 'دَرَنده', 'B1', 'B2'), -- predator / beast
  (204761, 'مَهار', 'B1', 'B2'), -- control / restraint (formal; مهار کردن = to control)
  (204762, 'اِعتِصاب', 'B1', 'B2'), -- strike [labor]
  (204765, 'هَمانَند', 'B2', 'C1'), -- similar to (formal)
  (204767, 'تَرَحُّم', 'B2', 'C1'), -- pity / compassion (formal)
  (204768, 'زیرَک', 'B1', 'B2'), -- clever / cunning
  (204770, 'مُهاجِم', 'B1', 'B2'), -- attacker / striker
  (204772, 'بادبان', 'B1', 'B2'), -- sail
  (204773, 'مُعالِجه', 'B1', 'B2'), -- treatment / cure (medical; معالجه کردن = to treat)
  (204774, 'صَلاحیَّت', 'B2', 'C1'), -- competence / qualification
  (204776, 'اِختِصاص', 'B1', 'B2'), -- allocation (اختصاص دادن = to allocate)
  (204777, 'تَجزیه', 'B2', 'C1'), -- decomposition / analysis (formal)
  (204778, 'کَندَن', 'B1', 'A2'), -- to dig / to pull out
  (204780, 'فِشَنگ', 'B1', 'B2'), -- bullet / cartridge
  (204782, 'لاشه', 'B2', 'C1'), -- carcass
  (204784, 'لَجَن', 'B1', 'B2'), -- mud / slime
  (204786, 'طاعون', 'B2', 'C1'), -- plague (disease)
  (204788, 'اِلتِهاب', 'B2', 'C1'), -- inflammation (medical)
  (204790, 'ذَوق', 'B1', 'B2'), -- delight / enthusiasm (formal)
  (204791, 'وَکالَت', 'B2', 'C1'), -- attorneyship / proxy (formal, legal)
  (204792, 'بازپُرس', 'B2', 'C1'), -- investigator [legal]
  (204793, 'دوز', 'B1', 'B2'), -- dose (loanword, medical)
  (204794, 'لُقمه', 'B1', 'B2'), -- bite / morsel [food]
  (204796, 'اِمکانات', 'B1', 'B2'), -- facilities / resources
  (204800, 'لال', 'B1', 'B2'), -- mute (unable to speak)
  (204801, 'مُحَقِّق', 'B1', 'B2'), -- researcher
  (204802, 'اِصابَت', 'B2', 'C1'), -- hitting / striking (formal, of a projectile)
  (204804, 'قُوَّت', 'B1', 'B2'), -- strength / power (formal)
  (204810, 'هورمون', 'B1', 'B2'), -- hormone (loanword)
  (204813, 'ساقدوش', 'B1', 'B2'), -- best man / bridesmaid
  (204815, 'جَمال', 'B2', 'C1'), -- beauty (formal)
  (204816, 'مُبهَم', 'B1', 'B2'), -- vague / ambiguous
  (204817, 'سِلسِله', 'B1', 'B2'), -- dynasty / series
  (204820, 'کَربَن', 'B1', 'B2'), -- carbon (loanword)
  (204824, 'وَرشِکَست', 'B1', 'B2'), -- bankrupt
  (204825, 'مُنجَمِد', 'B1', 'B2'), -- frozen
  (204826, 'ظُلم', 'B1', 'B2'), -- oppression / injustice (formal)
  (204827, 'وَثیقه', 'B2', 'C1'), -- bail / collateral (legal)
  (204828, 'پروسه', 'B1', 'B2'), -- process (loanword)
  (204829, 'دیوان', 'B2', 'C1'), -- court / tribunal
  (204830, 'وَسواس', 'B1', 'B2'), -- obsession / OCD
  (204832, 'اِستِدلال', 'B1', 'B2'), -- reasoning / argument (استدلال کردن = to reason)
  (204833, 'مَقبَره', 'B1', 'B2'), -- tomb / mausoleum
  (204835, 'کاهِن', 'B2', 'C1'), -- priest (ancient / pagan, formal)
  (204837, 'اِغراق', 'B1', 'B2'), -- exaggeration (اغراق کردن = to exaggerate)
  (204840, 'سَرگَردان', 'B1', 'B2'), -- wandering / lost / confused
  (204842, 'پِرسُنِل', 'B1', 'B2'), -- personnel (loanword)
  (204843, 'جَماعَت', 'B1', 'B2'), -- crowd / congregation
  (204845, 'مَعصوم', 'B1', 'B2'), -- innocent / pure
  (204846, 'مُختَصَر', 'B1', 'B2'), -- brief / concise
  (204849, 'آشتی', 'B1', 'B2'), -- reconciliation (آشتی کردن = to reconcile)
  (204850, 'اِنعِطاف', 'B1', 'B2'), -- flexibility
  (204851, 'نادِر', 'B1', 'B2'), -- rare
  (204855, 'ویرایِش', 'B1', 'B2'), -- editing (ویرایش کردن = to edit)
  (204856, 'مُقَرَّرات', 'B1', 'B2'), -- regulations
  (204857, 'تَجَسُّس', 'B2', 'C1'), -- investigation / search (formal)
  (204861, 'هُلو', 'A1', 'A2'), -- peach
  (204863, 'نَبات', 'B1', 'B2'), -- rock candy
  (204864, 'اُسطوره', 'B1', 'B2'), -- myth / legend
  (204865, 'شیفته', 'B2', 'C1'), -- infatuated / enamored (formal)
  (204866, 'تَقاص', 'B2', 'C1'), -- retribution (formal)
  (204867, 'حامِل', 'B2', 'C1'), -- carrier / bearer (formal)
  (204868, 'ظُهور', 'B1', 'B2'), -- emergence / appearance (formal)
  (204872, 'تَصویب', 'B2', 'C1'), -- approval / ratification (formal)
  (204873, 'رَخنه', 'B2', 'C1'), -- breach / infiltration (formal)
  (204874, 'تَشییع', 'B2', 'C1'), -- funeral procession (formal)
  (204875, 'تَعویض', 'B1', 'B2'), -- replacement (تعویض کردن = to replace)
  (204877, 'تَسلیَت', 'B1', 'B2'), -- condolences
  (204879, 'سَلطه', 'B2', 'C1'), -- dominance / hegemony (formal)
  (204882, 'کَبیر', 'B2', 'C1'), -- great (formal epithet)
  (204886, 'هَضم', 'B1', 'B2'), -- digestion (هضم کردن = to digest)
  (204889, 'مُتَصَدّی', 'B2', 'C1'), -- attendant / clerk (formal)
  (204890, 'مُدَّعی', 'B2', 'C1'), -- claimant / plaintiff (formal, legal)
  (204892, 'سِرنگ', 'B1', 'B2'), -- syringe
  (204893, 'شُمار', 'B1', 'B2'), -- count / number (formal; بی‌شمار = countless)
  (204894, 'ویران', 'B1', 'B2'), -- ruined / devastated
  (204895, 'مُعادِله', 'B1', 'B2'), -- equation
  (204898, 'آواره', 'B1', 'B2'), -- homeless / displaced
  (204899, 'جَسارَت', 'B1', 'B2'), -- audacity / courage (formal)
  (204903, 'توزیع', 'B1', 'B2'), -- distribution (توزیع کردن = to distribute)
  (204904, 'شَرارَت', 'B1', 'B2'), -- mischief / wickedness
  (204905, 'شاهین', 'B1', 'B2'), -- falcon
  (204906, 'مَفقود', 'B1', 'B2'), -- missing / lost
  (204907, 'بلوف', 'B1', 'B2'), -- bluff (loanword)
  (204909, 'مُزدور', 'B2', 'C1'), -- mercenary
  (204910, 'پَیامبَر', 'B1', 'B2'), -- prophet
  (204912, 'کَلانتَری', 'B1', 'B2'), -- police station
  (204913, 'هوشیار', 'B1', 'B2'), -- alert / conscious
  (204914, 'صَدراَعظَم', 'B2', 'C1'), -- prime minister / chancellor (historical)
  (204915, 'رَقصَنده', 'B1', 'B2'), -- dancer
  (204916, 'دادخواست', 'B2', 'C1'), -- lawsuit / petition (legal)
  (204917, 'گِرِفتگی', 'B1', 'B2'), -- cramp / blockage
  (204920, 'مُشارَکَت', 'B1', 'B2'), -- participation (formal)
  (204921, 'تَخَیُّل', 'B1', 'B2'), -- imagination (formal)
  (204922, 'پوزِش', 'B1', 'B2'), -- apology (formal)
  (204923, 'شیرجه', 'B1', 'B2'), -- dive (شیرجه زدن = to dive)
  (204924, 'ژانویه', 'A1', 'A2'), -- January
  (204925, 'چاشنی', 'B1', 'B2'), -- seasoning / condiment
  (204926, 'دِلسوزی', 'B1', 'B2'), -- compassion / sympathy (formal)
  (204929, 'لَحن', 'B1', 'B2'), -- tone [of voice]
  (204930, 'اُفُق', 'B1', 'B2'), -- horizon
  (204931, 'ضامِن', 'B2', 'C1'), -- guarantor; trigger [gun] (formal)
  (204933, 'سازگار', 'B1', 'B2'), -- compatible / adaptable
  (204935, 'سالانه', 'B1', 'B2'), -- annual / yearly
  (204936, 'اَحوال', 'B1', 'B2'), -- well-being / condition
  (204937, 'اِنتِها', 'B1', 'B2'), -- end / ending (formal)
  (204938, 'جِناح', 'B1', 'B2'), -- faction / wing [political]
  (204940, 'دَرَخشِش', 'B1', 'B2'), -- shine / brilliance
  (204941, 'شُعور', 'B1', 'B2'), -- consciousness / common sense
  (204942, 'عِزَّت', 'B1', 'B2'), -- honor / dignity (formal)
  (204943, 'اِنتِقاد', 'B1', 'B2'), -- criticism (انتقاد کردن = to criticize)
  (204944, 'بَدنام', 'B1', 'B2'), -- notorious / infamous
  (204945, 'پُرسِش', 'B1', 'B2'), -- question (formal)
  (204946, 'صَدر', 'B1', 'B2'), -- chest / top (formal; در صدر = at the top)
  (204947, 'اِرتِقا', 'B1', 'B2'), -- promotion / upgrade (ارتقا دادن = to upgrade)
  (204948, 'شَریف', 'B1', 'B2'), -- noble / honorable
  (204949, 'نِشیمَن', 'B1', 'B2'), -- living room; seat
  (204950, 'ناخودآگاه', 'B2', 'C1'), -- unconscious / subconscious
  (204951, 'مُفتَخَر', 'B1', 'B2'), -- honored / privileged (formal)
  (204952, 'عازِم', 'B1', 'B2'), -- departing / heading to (formal)
  (204953, 'شِکَننده', 'B1', 'B2'), -- fragile / breakable
  (204955, 'کِشِش', 'B1', 'B2'), -- pull / attraction (formal)
  (204956, 'اِجبار', 'B1', 'B2'), -- compulsion / coercion (formal)
  (204959, 'فِشُرده', 'B1', 'B2'), -- compressed / condensed
  (204960, 'مَجذوب', 'B2', 'C1'), -- captivated / fascinated (formal)
  (204962, 'جُداگانه', 'B1', 'B2'), -- separately
  (204963, 'هول', 'B1', 'B2'), -- panic / haste (هول شدن = to panic)
  (204964, 'مُسِن', 'B1', 'B2'), -- elderly / aged
  (204965, 'نَوازِش', 'B1', 'B2'), -- caress (نوازش کردن = to caress)
  (204967, 'گویا', 'B1', 'B2'), -- apparently / seemingly (formal)
  (204969, 'نَقلیه', 'B1', 'B2'), -- vehicle (formal; وسیله نقلیه)
  (204970, 'کانون', 'B1', 'B2'), -- center / focus; foundation (formal)
  (204971, 'یاغی', 'B1', 'B2'), -- rebellious / outlaw
  (204972, 'مُحَرِّک', 'B1', 'B2'), -- motive / stimulus (formal)
  (204973, 'قَدری', 'B1', 'B2'), -- a bit / somewhat
  (204974, 'خاصیَّت', 'B1', 'B2'), -- property / characteristic
  (204975, 'سَرکَش', 'B1', 'B2'), -- rebellious / unruly
  (204976, 'اِنفِرادی', 'B1', 'B2'), -- individual / solitary
  (204977, 'آمیزه', 'B2', 'C1'), -- blend / mixture (formal)
  (204978, 'اِفتِتاحیه', 'B1', 'B2'), -- opening ceremony
  (204979, 'فَلَک', 'B2', 'C1'), -- sky / fate (formal)
  (204980, 'اَخّاذی', 'B2', 'C1'), -- extortion (اخاذی کردن = to extort)
  (204981, 'نیازمَند', 'B1', 'B2'), -- in need of (formal)
  (204987, 'مَراتِب', 'B2', 'C1'), -- degrees / levels (formal; به‌مراتب = by far)
  (204988, 'ناظِر', 'B1', 'B2'), -- observer / supervisor
  (204989, 'یادبود', 'B1', 'B2'), -- memorial / souvenir
  (204990, 'حاوی', 'B1', 'B2'), -- containing (formal)
  (204992, 'مِسلَسَل', 'B1', 'B2'), -- machine gun
  (204993, 'مافوق', 'B2', 'C1'), -- superior [in rank] (formal)
  (204995, 'مَسافَت', 'B1', 'B2'), -- distance
  (204996, 'پِدَرخوانده', 'B1', 'B2'), -- godfather / adoptive father
  (204997, 'عَطا', 'B2', 'C1'), -- gift / bestowal (formal)
  (204998, 'نوکَر', 'B1', 'B2'), -- servant
  (204999, 'رَستگاری', 'B2', 'C1'), -- salvation
  (205000, 'مُتَقَلِّب', 'B1', 'B2'), -- fraudulent / cheater
  (205001, 'اُستوار', 'B1', 'B2'), -- firm / steadfast
  (205003, 'سِپاس', 'B1', 'B2'), -- thanks / gratitude (formal)
  (205004, 'تَظاهُرات', 'B1', 'B2'), -- demonstration / protest
  (205005, 'جَذّابیَّت', 'B1', 'B2'), -- attractiveness
  (205006, 'مُنتَخَب', 'B1', 'B2'), -- selected / elected
  (205008, 'خروس', 'A1', 'A2'), -- rooster
  (205010, 'مَجنون', 'B2', 'C1'), -- madly in love / insane (formal)
  (205011, 'مُتَجاوِز', 'B2', 'C1'), -- aggressor / trespasser (formal)
  (205012, 'خالِق', 'B1', 'B2'), -- creator (formal)
  (205013, 'اِقبال', 'B2', 'C1'), -- fortune / luck (formal)
  (205015, 'بالقُوّه', 'B2', 'C1'), -- potential
  (205016, 'طَرد', 'B2', 'C1'), -- rejection / expulsion (طرد کردن = to reject)
  (205017, 'اِستِعاره', 'B2', 'C1'), -- metaphor
  (205018, 'مُتَقابِل', 'B1', 'B2'), -- mutual / reciprocal
  (205019, 'حَجم', 'B1', 'B2'), -- volume / size
  (205020, 'خیمه', 'B1', 'B2'), -- tent
  (205023, 'صُعود', 'B1', 'B2'), -- ascent / climbing (صعود کردن = to climb)
  (205025, 'تَجویز', 'B1', 'B2'), -- prescription (تجویز کردن = to prescribe)
  (205028, 'عَظَمَت', 'B2', 'C1'), -- grandeur / greatness (formal)
  (205030, 'ساحِر', 'B1', 'B2'), -- sorcerer / magician
  (205031, 'دِهاتی', 'B1', 'B2'), -- villager / rural person
  (205032, 'دادرَسی', 'B2', 'C1'), -- legal proceedings / trial (formal)
  (205033, 'لَطیف', 'B1', 'B2'), -- gentle / delicate
  (205034, 'مُمتاز', 'B1', 'B2'), -- excellent / distinguished (formal)
  (205035, 'بَراق', 'B1', 'B2'), -- shiny / glossy
  (205037, 'تَرمیم', 'B1', 'B2'), -- repair / restoration (formal)
  (205038, 'مُنقَرِض', 'B2', 'C1'), -- extinct (منقرض شدن = to become extinct)
  (205039, 'حَک', 'B1', 'B2'), -- engraving (حک کردن = to engrave)
  (205040, 'تَصحیح', 'B1', 'B2'), -- correction (تصحیح کردن = to correct)
  (205041, 'تَشَعشُعات', 'B2', 'C1'), -- radiation (formal)
  (205043, 'مُلایِم', 'B1', 'B2'), -- mild / gentle
  (205044, 'مُصادِره', 'B2', 'C1'), -- confiscation (formal)
  (205045, 'مَعقول', 'B1', 'B2'), -- reasonable / sensible
  (205046, 'شانزدَه', 'A1', 'A2'), -- sixteen
  (205048, 'مُخَفَّف', 'B2', 'C1'), -- abbreviation
  (205050, 'نَشت', 'B1', 'B2'), -- leak (نشت کردن = to leak)
  (205051, 'مُختَل', 'B1', 'B2'), -- disrupted / disturbed (formal)
  (205052, 'خودرو', 'B1', 'B2'), -- vehicle / car (formal)
  (205053, 'آستانه', 'B1', 'B2'), -- threshold
  (205054, 'نوزدَه', 'A1', 'A2'), -- nineteen
  (205055, 'مُقَدَّمات', 'B1', 'B2'), -- preliminaries / preparations (formal)
  (205056, 'مُتلاشی', 'B2', 'C1'), -- shattered / destroyed (formal)
  (205057, 'فَراز', 'B2', 'C1'), -- height / peak (formal)
  (205058, 'نَظاره', 'B2', 'C1'), -- observation / watching (formal)
  (205059, 'گِردباد', 'B1', 'B2'), -- whirlwind / tornado
  (205060, 'واروَنه', 'B1', 'B2'), -- upside down / inverted
  (205061, 'کِبریت', 'A1', 'A2'), -- matches [fire-starting]
  (205063, 'نَبض', 'B1', 'B2'), -- pulse (medical)
  (205064, 'حَفّاری', 'B1', 'B2'), -- excavation / digging (حفاری کردن = to excavate)
  (205065, 'نَصیب', 'B2', 'C1'), -- portion / fate (formal)
  (205066, 'سَهیم', 'B1', 'B2'), -- having a share (formal)
  (205068, 'تَجَسُّم', 'B2', 'C1'), -- visualization (formal; تجسم کردن = to visualize)
  (205069, 'خیز', 'B1', 'B2'), -- leap / jump (خیز برداشتن = to leap)
  (205070, 'ظَرفیَّت', 'B1', 'B2'), -- capacity
  (205071, 'ناتَوان', 'B1', 'B2'), -- incapable / disabled
  (205072, 'پیکَر', 'B2', 'C1'), -- body / figure (formal)
  (205073, 'راهزَن', 'B2', 'C1'), -- highway robber / bandit
  (205074, 'دادگُستَری', 'B2', 'C1'), -- judiciary / ministry of justice (formal)
  (205076, 'کُلِکسیون', 'B1', 'B2'), -- collection (loanword)
  (205079, 'نَهُفته', 'B2', 'C1'), -- hidden / latent (formal)
  (205080, 'مَملو', 'B2', 'C1'), -- full of / replete (formal)
  (205081, 'سَبَب', 'B1', 'B2'), -- cause / reason (formal)
  (205082, 'خارِش', 'B1', 'B2'), -- itching (خارش داشتن = to itch)
  (205083, 'سَلّاخی', 'B2', 'C1'), -- slaughter (سلاخی کردن = to slaughter)
  (205086, 'مُنزَجِر', 'B2', 'C1'), -- disgusted (formal)
  (205088, 'مَنصوب', 'B2', 'C1'), -- appointed (formal; منصوب کردن = to appoint)
  (205089, 'اَجیر', 'B2', 'C1'), -- hired / mercenary (اجیر کردن = to hire)
  (205091, 'خُصوصیات', 'B1', 'B2'), -- characteristics / properties (formal)
  (205092, 'گِردهَمایی', 'B2', 'C1'), -- gathering / assembly (formal)
  (205093, 'پَرتگاه', 'B1', 'B2'), -- cliff / precipice
  (205094, 'آبرو', 'B1', 'B2'), -- reputation / honor (formal)
  (205095, 'نَظافَت', 'B1', 'B2'), -- cleaning (formal; نظافت کردن = to clean)
  (205096, 'ناچیز', 'B1', 'B2'), -- insignificant / trivial
  (205097, 'مَملَکَت', 'B1', 'B2'), -- country / kingdom (formal)
  (205098, 'اِمتِناع', 'B2', 'C1'), -- refusal (formal; امتناع کردن = to refuse)
  (205099, 'اِنعِکاس', 'B2', 'C1'), -- reflection / echo (formal)
  (205100, 'حاشیه', 'B1', 'B2'), -- margin / periphery
  (205101, 'وَخیم', 'B2', 'C1'), -- severe / critical (formal)
  (205103, 'مافیا', 'B1', 'B2'), -- mafia (loanword)
  (205104, 'عاطِفه', 'B1', 'B2'), -- emotion / affection (formal)
  (205105, 'مَرطوب', 'B1', 'B2'), -- humid / moist
  (205106, 'شِپِش', 'B1', 'B2'), -- lice
  (205107, 'تَطابُق', 'B2', 'C1'), -- conformity / matching (formal)
  (205109, 'ثَمَر', 'B2', 'C1'), -- fruit / result (formal)
  (205110, 'پَردازِش', 'B1', 'B2'), -- processing (formal)
  (205111, 'اِنحِراف', 'B1', 'B2'), -- deviation (formal)
  (205112, 'مَجموع', 'B1', 'B2'), -- total / sum (formal)
  (205113, 'اِمتِداد', 'B2', 'C1'), -- extension / continuation (formal)
  (205117, 'حِفاظ', 'B1', 'B2'), -- guard / protective barrier
  (205118, 'فُقدان', 'B2', 'C1'), -- lack / absence (formal)
  (205119, 'پَروا', 'B2', 'C1'), -- fear / concern (formal; بی‌پروا = fearless)
  (205121, 'تَسَلُّط', 'B1', 'B2'), -- dominance / mastery (formal)
  (205122, 'قُرعه', 'B1', 'B2'), -- lottery / draw (formal)
  (205123, 'هوشمَند', 'B1', 'B2'), -- intelligent / smart (formal)
  (205124, 'نامُناسِب', 'B1', 'B2'), -- unsuitable / inappropriate
  (205125, 'حَسرَت', 'B1', 'B2'), -- regret / longing (formal)
  (205126, 'اِمداد', 'B1', 'B2'), -- aid / rescue (formal)
  (205127, 'مُبَدَّل', 'B2', 'C1'), -- disguised / converted (formal)
  (205129, 'باتلاق', 'B1', 'B2'), -- swamp / marsh
  (205131, 'مُتَحَمِّل', 'B2', 'C1'), -- enduring / incurring (formal)
  (205132, 'جاسازی', 'B1', 'B2'), -- concealment / embedding (جاسازی کردن = to conceal)
  (205135, 'اِبتِکار', 'B1', 'B2'), -- initiative (formal)
  (205137, 'اَطلَس', 'B1', 'B2'), -- atlas
  (205138, 'نَوا', 'B2', 'C1'), -- melody (formal)
  (205139, 'ریا', 'B2', 'C1'), -- hypocrisy (formal)
  (205140, 'دادرَس', 'B2', 'C1'), -- judge / adjudicator (formal)
  (205141, 'تَعلیق', 'B2', 'C1'), -- suspension (formal)
  (205142, 'اَفسار', 'B1', 'B2'), -- reins / bridle
  (205143, 'فَرعی', 'B1', 'B2'), -- secondary / minor (formal)
  (205144, 'مانِوَر', 'B1', 'B2'), -- maneuver
  (205145, 'مُعاشِرَت', 'B2', 'C1'), -- socializing (formal; معاشرت کردن = to socialize)
  (205146, 'اِحیا', 'B1', 'B2'), -- revival / restoration (formal; احیا کردن = to revive)
  (205147, 'بَقا', 'B1', 'B2'), -- survival (formal)
  (205149, 'ظَریف', 'B1', 'B2'), -- delicate / subtle
  (205150, 'دوبله', 'B1', 'B2'), -- dubbing [film]
  (205151, 'تَخمین', 'B1', 'B2'), -- estimate (formal; تخمین زدن = to estimate)
  (205152, 'شَراکَت', 'B1', 'B2'), -- partnership (formal)
  (205154, 'حَلال', 'B1', 'B2'), -- permissible / halal (religious)
  (205156, 'حِرص', 'B1', 'B2'), -- greed / eagerness (informal)
  (205157, 'اَسارَت', 'B1', 'B2'), -- captivity (formal)
  (205158, 'بَرمَلا', 'B2', 'C1'), -- exposed / revealed (formal)
  (205159, 'پَلید', 'B2', 'C1'), -- wicked / evil (formal, literary)
  (205160, 'دوجین', 'B1', 'B2'), -- dozen
  (205161, 'خودداری', 'B1', 'B2'), -- abstention (formal; خودداری کردن = to refrain)
  (205162, 'گانگستِر', 'B1', 'B2'), -- gangster (loanword)
  (205163, 'خوشایَند', 'B1', 'B2'), -- pleasant (formal)
  (205164, 'هاله', 'B1', 'B2'), -- halo / aura
  (205165, 'پَرورِشگاه', 'B1', 'B2'), -- orphanage / nursery
  (205167, 'بَرکَنار', 'B2', 'C1'), -- dismissed / removed [from office] (formal)
  (205169, 'سَپیده', 'B1', 'B2'), -- dawn (poetic)
  (205170, 'زاری', 'B2', 'C1'), -- lamentation (formal)
  (205171, 'اِعطا', 'B2', 'C1'), -- granting / bestowal (formal)
  (205173, 'لَگَن', 'B1', 'B2'), -- pelvis; basin
  (205175, 'شاکی', 'B1', 'B2'), -- plaintiff [legal]
  (205176, 'پَدیدار', 'B2', 'C1'), -- apparent / emergent (formal)
  (205177, 'دائِماً', 'B1', 'B2'), -- constantly (formal)
  (205178, 'تَحمیل', 'B1', 'B2'), -- imposition (formal; تحمیل کردن = to impose)
  (205179, 'بازرگانی', 'B1', 'B2'), -- commerce / trade (formal)
  (205181, 'داروخانه', 'A1', 'A2'), -- pharmacy
  (205182, 'قیام', 'B1', 'B2'), -- uprising / revolt (formal)
  (205183, 'سَربُلَند', 'B1', 'B2'), -- proud / successful (formal)
  (205184, 'خاوَرمیانه', 'B1', 'B2'), -- Middle East
  (205188, 'بازتاب', 'B1', 'B2'), -- reflection / repercussion (formal)
  (205189, 'غَرامَت', 'B2', 'C1'), -- compensation / indemnity (formal, legal)
  (205190, 'نَحو', 'B2', 'C1'), -- manner / syntax (formal)
  (205192, 'آسوده', 'B1', 'B2'), -- at ease / comfortable (formal)
  (205194, 'خویش', 'B2', 'C1'), -- self / one's own (formal)
  (205195, 'عِبرَت', 'B2', 'C1'), -- lesson / moral (formal)
  (205196, 'مُضحِک', 'B1', 'B2'), -- ridiculous / comical (formal)
  (205197, 'تَبَهکار', 'B1', 'B2'), -- criminal / villain (formal)
  (205198, 'تَباه', 'B2', 'C1'), -- ruined / corrupted (formal)
  (205200, 'دایناسور', 'A1', 'A2'), -- dinosaur (loanword)
  (205201, 'ناموفَّق', 'B1', 'B2'), -- unsuccessful
  (205203, 'مُستَخدَم', 'B2', 'C1'), -- servant / employee (formal, dated)
  (205204, 'هیپنوتیزم', 'B1', 'B2'), -- hypnosis (loanword)
  (205206, 'آسایشگاه', 'B1', 'B2'), -- sanatorium / rest home
  (205207, 'آسایِش', 'B1', 'B2'), -- comfort / ease (formal)
  (205208, 'پادگان', 'B1', 'B2'), -- military barracks
  (205209, 'لَطمه', 'B1', 'B2'), -- harm / damage (formal; لطمه زدن = to harm)
  (205210, 'ناهَنجاری', 'B2', 'C1'), -- abnormality / anomaly (formal)
  (205211, 'سَخاوَتمَند', 'B1', 'B2'), -- generous
  (205212, 'تِراژِدی', 'B1', 'B2'), -- tragedy (loanword)
  (205213, 'طاق', 'B1', 'B2'), -- arch
  (205216, 'مُهَیّا', 'B2', 'C1'), -- ready / prepared (formal)
  (205217, 'مُصالِحه', 'B2', 'C1'), -- compromise / settlement (formal)
  (205218, 'صِحَّت', 'B1', 'B2'), -- accuracy / health (formal)
  (205220, 'سانِحه', 'B1', 'B2'), -- accident / incident (formal)
  (205221, 'مایوس', 'B1', 'B2'), -- disappointed / despairing (formal)
  (205222, 'اَغوا', 'B2', 'C1'), -- seduction (formal)
  (205224, 'مَعنَوی', 'B1', 'B2'), -- spiritual (formal)
  (205225, 'چُماق', 'B1', 'B2'), -- club / cudgel [weapon]
  (205227, 'مَجمَع', 'B1', 'B2'), -- assembly / council (formal)
  (205228, 'وَفا', 'B1', 'B2'), -- loyalty / faithfulness (formal)
  (205229, 'توپخانه', 'B2', 'C1'), -- artillery
  (205230, 'نامَشروع', 'B2', 'C1'), -- illegitimate (formal)
  (205231, 'گُریز', 'B1', 'B2'), -- escape / flight (formal)
  (205232, 'اَثاثیه', 'B1', 'B2'), -- furniture / belongings (formal)
  (205233, 'آنگاه', 'B2', 'C1'), -- then / at that time (formal)
  (205234, 'غُبار', 'B1', 'B2'), -- dust (formal)
  (205238, 'تَعویق', 'B1', 'B2'), -- postponement (formal)
  (205239, 'حَولِ', 'B2', 'C1'), -- around (formal)
  (205240, 'چروک', 'B1', 'B2'), -- wrinkle
  (205241, 'طَویله', 'B1', 'B2'), -- stable [for animals]
  (205242, 'زوزه', 'B1', 'B2'), -- howl (زوزه کشیدن = to howl)
  (205243, 'اَهریمَن', 'B2', 'C1'), -- demon / evil spirit (formal)
  (205244, 'تَفسیر', 'B1', 'B2'), -- interpretation / commentary (formal)
  (205245, 'مَنظومه', 'B1', 'B2'), -- solar system
  (205247, 'تَهاجُم', 'B2', 'C1'), -- aggression / invasion (formal)
  (205248, 'شِگِفتی', 'B1', 'B2'), -- astonishment / wonder (formal)
  (205249, 'اَمانَت', 'B1', 'B2'), -- trust / deposit (formal)
  (205250, 'تَلَقّی', 'B2', 'C1'), -- perception / consideration (formal)
  (205251, 'عَقد', 'B1', 'B2'), -- marriage contract (formal)
  (205253, 'حَلق', 'B1', 'B2'), -- throat (formal)
  (205256, 'سِمبُل', 'B1', 'B2'), -- symbol (loanword)
  (205258, 'کَمپین', 'B1', 'B2'), -- campaign (loanword)
  (205259, 'مُشاجِره', 'B1', 'B2'), -- argument / dispute (formal)
  (205261, 'کِشمَکِش', 'B1', 'B2'), -- conflict / struggle (formal)
  (205262, 'سَرزَده', 'B1', 'B2'), -- unannounced / sudden (formal)
  (205263, 'گَنگ', 'B1', 'B2'), -- vague / mumbling
  (205264, 'جَلّاد', 'B1', 'B2'), -- executioner
  (205265, 'غَنیمَت', 'B2', 'C1'), -- loot / spoils (formal)
  (205266, 'عَزاداری', 'B1', 'B2'), -- mourning (formal)
  (205267, 'کارساز', 'B1', 'B2'), -- effective / useful (formal)
  (205269, 'خاکسِپاری', 'B1', 'B2'), -- burial (formal)
  (205270, 'قِراضه', 'B1', 'B2'), -- junk / scrap (informal)
  (205271, 'نامَعلوم', 'B1', 'B2'), -- unknown / unspecified
  (205273, 'بازیابی', 'B2', 'C1'), -- retrieval / recovery (formal)
  (205274, 'وَلیعَهد', 'B2', 'C1'), -- crown prince (formal)
  (205277, 'واعِظ', 'B2', 'C1'), -- preacher (formal)
  (205278, 'اَمین', 'B1', 'B2'), -- trustworthy / honest
  (205279, 'خِزَنده', 'B1', 'B2'), -- reptile / creeping (formal)
  (205280, 'بَندَرگاه', 'B1', 'B2'), -- port / harbor
  (205282, 'دَریاسالار', 'B2', 'C1'), -- admiral
  (205283, 'نُبوغ', 'B2', 'C1'), -- genius / brilliance (formal)
  (205284, 'اِیدز', 'B1', 'B2'), -- AIDS (medical, loanword)
  (205285, 'حُضّار', 'B1', 'B2'), -- audience / attendees (formal)
  (205286, 'مؤَنَّث', 'B2', 'C1'), -- female / feminine [grammar] (formal)
  (205287, 'تَطبیق', 'B1', 'B2'), -- adaptation / matching (formal)
  (205290, 'سوءتَفاهُم', 'B1', 'B2'), -- misunderstanding (formal)
  (205293, 'سُخَنگو', 'B1', 'B2'), -- spokesperson (formal)
  (205294, 'خِلال', 'B2', 'C1'), -- during (formal; در خلال = during)
  (205296, 'مُقَدَّر', 'B2', 'C1'), -- predestined / fated (formal)
  (205297, 'قَضا', 'B2', 'C1'), -- fate / destiny (formal)
  (205298, 'سازِش', 'B1', 'B2'), -- compromise / appeasement (formal)
  (205299, 'فَوّاره', 'B1', 'B2'), -- fountain
  (205300, 'بانکدار', 'B1', 'B2'), -- banker
  (205301, 'مَغلوب', 'B2', 'C1'), -- defeated (formal)
  (205303, 'دِلتَنگ', 'B1', 'B2'), -- homesick / longing (formal)
  (205304, 'غیرفَعّال', 'B1', 'B2'), -- inactive
  (205305, 'سَرپَناه', 'B1', 'B2'), -- shelter
  (205307, 'ضَربدَر', 'B2', 'C1'), -- multiplication sign / cross mark (formal)
  (205308, 'آهَنین', 'B2', 'C1'), -- iron-made / of iron (formal)
  (205309, 'تَسلیحات', 'B2', 'C1'), -- armaments / weapons (formal)
  (205312, 'دَوَنده', 'B1', 'B2'), -- runner
  (205314, 'عُصاره', 'B2', 'C1'), -- extract / essence (formal)
  (205315, 'گِرامی', 'B1', 'B2'), -- dear / esteemed (formal)
  (205316, 'آغِشته', 'B2', 'C1'), -- soaked / coated (formal)
  (205318, 'کورکورانه', 'B1', 'B2'), -- blindly
  (205319, 'بیننده', 'B1', 'B2'), -- viewer
  (205322, 'نامَحدود', 'B1', 'B2'), -- unlimited
  (205323, 'اَحسَنت', 'B1', 'B2'), -- well done! / bravo! (formal)
  (205325, 'تَداخُل', 'B2', 'C1'), -- interference / overlap (formal)
  (205326, 'گُمرُک', 'B1', 'B2'), -- customs [border]
  (205327, 'دِگَرگون', 'B2', 'C1'), -- transformed / changed (formal)
  (205330, 'سَردَرگُم', 'B1', 'B2'), -- confused / bewildered
  (205331, 'پایبَند', 'B1', 'B2'), -- committed / adherent (formal)
  (205333, 'پتانسیل', 'B1', 'B2'), -- potential (loanword)
  (205334, 'اَقوام', 'B1', 'B2'), -- relatives / kinsfolk (formal)
  (205336, 'صِدق', 'B2', 'C1'), -- truth / validity (formal)
  (205337, 'طالِع', 'B2', 'C1'), -- fortune / horoscope (formal)
  (205339, 'راکتور', 'B1', 'B2'), -- reactor (loanword)
  (205340, 'گِدا', 'B1', 'B2'), -- beggar
  (205341, 'مُتَعَصِّب', 'B1', 'B2'), -- fanatic / bigoted (formal)
  (205342, 'سَرنِشین', 'B1', 'B2'), -- passenger / occupant
  (205346, 'سَرزِنده', 'B1', 'B2'), -- lively / vivacious (formal)
  (205347, 'ناب', 'B1', 'B2'), -- pure / genuine (formal)
  (205351, 'مَدَنی', 'B1', 'B2'), -- civil / civic (formal)
  (205352, 'فَسخ', 'B2', 'C1'), -- cancellation / annulment (formal, legal)
  (205354, 'عَینی', 'B1', 'B2'), -- objective (formal)
  (205356, 'مَزیَّت', 'B1', 'B2'), -- advantage (formal)
  (205357, 'ساق', 'B1', 'B2'), -- shin / stem (formal)
  (205360, 'خُرما', 'A1', 'A2'), -- date [fruit]
  (205361, 'سَروَقت', 'B1', 'B2'), -- promptly / on time (formal)
  (205362, 'سوپِرمارکِت', 'A1', 'A2'), -- supermarket (loanword)
  (205363, 'صوت', 'B1', 'B2'), -- sound / voice (formal)
  (205364, 'حاد', 'B1', 'B2'), -- acute / severe (formal)
  (205365, 'جیره', 'B1', 'B2'), -- ration
  (205366, 'تَبعیض', 'B1', 'B2'), -- discrimination (formal)
  (205367, 'مُهَیِّج', 'B1', 'B2'), -- exciting / thrilling (formal)
  (205370, 'رؤیا', 'B1', 'B2'), -- dream / vision (formal, aspirational)
  (205371, 'لات', 'B1', 'B2'), -- thug / hoodlum (informal)
  (205372, 'مُجتَمِع', 'B1', 'B2'), -- complex / apartment building (formal)
  (205373, 'تُندرَو', 'B2', 'C1'), -- radical / extremist
  (205374, 'جَنجال', 'B1', 'B2'), -- controversy / uproar (formal)
  (205376, 'نُمایان', 'B1', 'B2'), -- visible / apparent (formal)
  (205377, 'طومار', 'B2', 'C1'), -- scroll (formal, historical)
  (205378, 'اِرتِکاب', 'B2', 'C1'), -- commission [of a crime] (formal)
  (205380, 'مَصونیَّت', 'B2', 'C1'), -- immunity (formal, legal / medical)
  (205383, 'شُلَخته', 'B1', 'B2'), -- sloppy / disheveled (informal)
  (205384, 'تاکتیک', 'B1', 'B2'), -- tactic (loanword)
  (205385, 'دُرُستکار', 'B1', 'B2'), -- honest / upright (formal)
  (205387, 'دینامیت', 'B1', 'B2'), -- dynamite (loanword)
  (205388, 'اِنصِراف', 'B1', 'B2'), -- withdrawal / cancellation (formal)
  (205389, 'دُرُشکه', 'B1', 'B2'), -- horse-drawn carriage
  (205390, 'وَقار', 'B2', 'C1'), -- dignity / gravitas (formal)
  (205391, 'بَدرَفتاری', 'B1', 'B2'), -- mistreatment (formal)
  (205392, 'غیرنِظامی', 'B1', 'B2'), -- civilian
  (205393, 'چِگونِگی', 'B2', 'C1'), -- how-ness / manner (formal)
  (205394, 'لُزوم', 'B1', 'B2'), -- necessity (formal)
  (205396, 'قِسط', 'B1', 'B2'), -- installment [payment] (formal)
  (205397, 'یِگان', 'B1', 'B2'), -- unit [military]
  (205398, 'نُمودار', 'B1', 'B2'), -- chart / diagram (formal)
  (205399, 'مُعَیَّن', 'B1', 'B2'), -- specific / determined (formal)
  (205400, 'دُرُشت', 'B1', 'B2'), -- large / coarse
  (205401, 'سایبِری', 'B1', 'B2'), -- cyber
  (205402, 'خودنِمایی', 'B1', 'B2'), -- showing off (formal)
  (205403, 'اِشتِغال', 'B1', 'B2'), -- employment (formal)
  (205405, 'دِلواپَس', 'B1', 'B2'), -- worried / anxious (formal)
  (205406, 'غُرِّش', 'B1', 'B2'), -- roar (غرش کردن = to roar)
  (205407, 'بَهادار', 'B2', 'C1'), -- valuable (formal; اوراق بهادار = securities)
  (205408, 'رَذل', 'B2', 'C1'), -- vile / despicable (formal)
  (205411, 'سَردار', 'B1', 'B2'), -- commander / general (formal)
  (205413, 'جامِع', 'B1', 'B2'), -- comprehensive (formal)
  (205414, 'جُرعه', 'B1', 'B2'), -- sip / gulp (formal)
  (205415, 'هواشِناسی', 'B1', 'B2'), -- meteorology
  (205416, 'تَشدید', 'B1', 'B2'), -- intensification (formal; تشدید کردن = to intensify)
  (205418, 'هَراس', 'B1', 'B2'), -- fear / terror (formal)
  (205419, 'عَلیرَغم', 'B2', 'C1'), -- despite (formal)
  (205420, 'مُعادِل', 'B1', 'B2'), -- equivalent (formal)
  (205421, 'مُخَرِّب', 'B1', 'B2'), -- destructive (formal)
  (205422, 'وُسعَت', 'B1', 'B2'), -- extent / vastness (formal)
  (205423, 'مَشغَله', 'B1', 'B2'), -- business / preoccupation (formal)
  (205425, 'کاربُرد', 'B1', 'B2'), -- usage / application (formal)
  (205427, 'مُقَرَّر', 'B2', 'C1'), -- stipulated / prescribed (formal)
  (205428, 'تِروریسم', 'B1', 'B2'), -- terrorism (loanword)
  (205429, 'تَمَسخُر', 'B1', 'B2'), -- mockery (formal; تمسخر کردن = to mock)
  (205430, 'مَوعِد', 'B1', 'B2'), -- deadline / appointed time (formal)
  (205431, 'رِختکَن', 'B1', 'B2'), -- locker room / changing room
  (205433, 'صَید', 'B1', 'B2'), -- hunting / catching [fish/game] (formal)
  (205434, 'سَرنِگون', 'B2', 'C1'), -- overthrown (formal; سرنگون کردن = to overthrow)
  (205435, 'اَنبوه', 'B1', 'B2'), -- abundant / dense (formal)
  (205436, 'دَرمانده', 'B1', 'B2'), -- helpless / desperate (formal)
  (205437, 'قَحطی', 'B1', 'B2'), -- famine
  (205438, 'عَجولانه', 'B1', 'B2'), -- hastily
  (205439, 'مَرحوم', 'B1', 'B2'), -- deceased / late [honorific] (formal)
  (205440, 'نورانی', 'B1', 'B2'), -- luminous / radiant (formal)
  (205441, 'چاپلوسی', 'B1', 'B2'), -- flattery / sycophancy (formal)
  (205442, 'تَکاوَر', 'B1', 'B2'), -- commando
  (205446, 'سامانه', 'B1', 'B2'), -- system (formal, tech)
  (205447, 'شِریان', 'B2', 'C1'), -- artery (medical, formal)
  (205448, 'اِبداع', 'B1', 'B2'), -- innovation (formal; ابداع کردن = to innovate)
  (205449, 'بازیچه', 'B1', 'B2'), -- toy / plaything (formal, figurative)
  (205452, 'ویراستار', 'B1', 'B2'), -- editor
  (205453, 'کودِتا', 'B1', 'B2'), -- coup d'état (formal / political)
  (205454, 'جَسورانه', 'B1', 'B2'), -- boldly
  (205457, 'مَجرا', 'B2', 'C1'), -- channel / duct (formal, technical)
  (205458, 'دَرگُذَشت', 'B1', 'B2'), -- passing away / death (formal)
  (205459, 'نامُشَخَّص', 'B1', 'B2'), -- unspecified
  (205460, 'یورِش', 'B1', 'B2'), -- assault / raid (formal)
  (205462, 'تَماماً', 'B1', 'B2'), -- entirely / completely (formal)
  (205463, 'مَحلول', 'B1', 'B2'), -- solution [chemistry] (formal)
  (205465, 'مُطلَقاً', 'B1', 'B2'), -- absolutely (formal)
  (205466, 'رَمزگُشایی', 'B1', 'B2'), -- decoding / decryption (formal, tech)
  (205468, 'مُحتَمَل', 'B1', 'B2'), -- probable / likely (formal)
  (205469, 'مَثانه', 'B2', 'C1'), -- bladder (medical)
  (205470, 'اَطفال', 'B1', 'B2'), -- children (formal)
  (205471, 'بینایی', 'B1', 'B2'), -- eyesight / vision (formal)
  (205472, 'باکِلاس', 'B1', 'B2'), -- classy (informal)
  (205473, 'تَکذیب', 'B1', 'B2'), -- denial (formal; تکذیب کردن = to deny)
  (205477, 'هَمایِش', 'B1', 'B2'), -- conference / convention (formal)
  (205478, 'اَکثَریَّت', 'B1', 'B2'), -- majority (formal)
  (205480, 'وَجد', 'B2', 'C1'), -- ecstasy / rapture (formal)
  (205481, 'عِرفان', 'B2', 'C1'), -- mysticism (formal)
  (205482, 'بُنیاد', 'B1', 'B2'), -- foundation (institution, formal)
  (205483, 'توانا', 'B1', 'B2'), -- capable / able (formal)
  (205484, 'بیرَحم', 'B1', 'B2'), -- merciless
  (205485, 'تَحَوُّل', 'B1', 'B2'), -- transformation (formal)
  (205486, 'روزَنه', 'B2', 'C1'), -- opening / aperture; opportunity (formal)
  (205487, 'لاف', 'B1', 'B2'), -- boasting (لاف زدن = to boast)
  (205488, 'غَفلَت', 'B2', 'C1'), -- negligence (formal)
  (205489, 'پاتوق', 'B1', 'B2'), -- hangout spot (informal)
  (205491, 'یَدَک', 'B1', 'B2'), -- spare / tow (یدک کشیدن = to tow)
  (205492, 'قُلدُر', 'B1', 'B2'), -- bully / thug
  (205494, 'خَلّاق', 'B1', 'B2'), -- creative (formal)
  (205495, 'اِکتِشاف', 'B1', 'B2'), -- exploration / discovery (formal)
  (205496, 'نازِل', 'B2', 'C1'), -- low / cheap [quality] (formal)
  (205497, 'ایستادگی', 'B1', 'B2'), -- resistance / standing firm (formal)
  (205499, 'پیشوا', 'B2', 'C1'), -- leader (formal, historical / religious)
  (205501, 'شِشصَد', 'A1', 'A2'), -- six hundred
  (205502, 'نامَربوط', 'B1', 'B2'), -- irrelevant
  (205504, 'رُجوع', 'B1', 'B2'), -- referral / reference (formal)
  (205505, 'فَلاکَت', 'B2', 'C1'), -- misery / misfortune (formal)
  (205506, 'خِپِل', 'B1', 'B2'), -- chubby (informal)
  (205507, 'تَحَقُّق', 'B1', 'B2'), -- realization / fulfillment (formal)
  (205508, 'جَزر', 'B2', 'C1'), -- low tide (formal)
  (205510, 'مُطیع', 'B1', 'B2'), -- obedient (formal)
  (205511, 'نیرومَند', 'B1', 'B2'), -- powerful / strong (formal)
  (205512, 'کَرانه', 'B1', 'B2'), -- shore / bank (formal)
  (205513, 'دُروغین', 'B1', 'B2'), -- false / fake (formal)
  (205514, 'رِفاقَت', 'B1', 'B2'), -- friendship (formal)
  (205515, 'تَعبیر', 'B1', 'B2'), -- interpretation [dreams] (formal)
  (205516, 'مَعدود', 'B1', 'B2'), -- few / limited in number (formal)
  (205517, 'گُلبول', 'B1', 'B2'), -- blood cell (formal, medical)
  (205520, 'فاقِد', 'B1', 'B2'), -- lacking (formal)
  (205522, 'بیسکویت', 'A1', 'A2'), -- biscuit / cookie (loanword)
  (205524, 'زَناشویی', 'B1', 'B2'), -- marital (formal)
  (205525, 'فِدِراسیون', 'B1', 'B2'), -- federation (loanword)
  (205526, 'دوطَرَفه', 'B1', 'B2'), -- two-way / bilateral (formal)
  (205527, 'حِکمَت', 'B2', 'C1'), -- wisdom (formal)
  (205528, 'مَکث', 'B1', 'B2'), -- pause (formal; مکث کردن = to pause)
  (205529, 'قِیامَت', 'B1', 'B2'), -- Judgment Day / doomsday
  (205530, 'مُستَعمَره', 'B1', 'B2'), -- colony (formal, historical)
  (205532, 'نامَرد', 'B1', 'B2'), -- unmanly / coward (informal)
  (205534, 'مَحکومیَّت', 'B1', 'B2'), -- conviction / sentence [legal] (formal)
  (205535, 'نَجابَت', 'B2', 'C1'), -- decency / chastity (formal)
  (205536, 'ماوَراء', 'B2', 'C1'), -- beyond / transcendent (formal)
  (205537, 'اِصلاحات', 'B1', 'B2'), -- reforms (formal)
  (205538, 'غَنی', 'B1', 'B2'), -- rich / wealthy (formal)
  (205539, 'تَثبیت', 'B1', 'B2'), -- stabilization (formal; تثبیت کردن = to stabilize)
  (205540, 'تَسَلّی', 'B1', 'B2'), -- consolation (formal; تسلی دادن = to console)
  (205541, 'بَدَوی', 'B2', 'C1'), -- primitive (formal)
  (205542, 'اِستِرداد', 'B2', 'C1'), -- extradition / return (formal, legal)
  (205543, 'روپوش', 'B1', 'B2'), -- overcoat / lab coat
  (205544, 'دِلسَرد', 'B1', 'B2'), -- discouraged (formal)
  (205545, 'غِلاف', 'B1', 'B2'), -- sheath / case (formal)
  (205546, 'نِگَرِش', 'B1', 'B2'), -- attitude / perspective (formal)
  (205547, 'پیگَرد', 'B2', 'C1'), -- prosecution (formal, legal)
  (205548, 'جُستُجوگَر', 'B1', 'B2'), -- searcher / search engine (formal, tech)
  (205549, 'مَوعود', 'B2', 'C1'), -- promised [one] (formal / religious)
  (205550, 'گوینده', 'B1', 'B2'), -- speaker / announcer (formal)
  (205551, 'رَهن', 'B2', 'C1'), -- mortgage (formal, financial)
  (205552, 'تَسمه', 'B1', 'B2'), -- belt / strap (mechanical)
  (205553, 'خُماری', 'B1', 'B2'), -- hangover feeling / craving (informal)
  (205554, 'تَپانچه', 'B1', 'B2'), -- pistol / handgun
  (205555, 'دَسیسه', 'B2', 'C1'), -- conspiracy / intrigue (formal)
  (205557, 'رُطوبَت', 'B1', 'B2'), -- humidity / moisture (formal)
  (205559, 'تِریاک', 'B1', 'B2'), -- opium
  (205560, 'مُذَکَّر', 'B2', 'C1'), -- male / masculine [grammar] (formal)
  (205561, 'آلو', 'A1', 'A2'), -- plum
  (205562, 'عِلاج', 'B1', 'B2'), -- cure / remedy (formal)
  (205563, 'آسپیرین', 'A2', 'B1'), -- aspirin (loanword)
  (205564, 'آفریده', 'B2', 'C1'), -- created / creature (formal)
  (205565, 'مَرحَمَت', 'B2', 'C1'), -- kindness / favor (formal, archaic)
  (205567, 'تَخَلُّف', 'B1', 'B2'), -- violation / offense (formal, legal)
  (205568, 'مَنفور', 'B2', 'C1'), -- hated / despised (formal)
  (205569, 'مَبهوت', 'B2', 'C1'), -- astonished / stunned (formal)
  (205571, 'اِنسِداد', 'B2', 'C1'), -- blockage / obstruction (formal)
  (205572, 'وَراجی', 'B1', 'B2'), -- chattering / gossip (informal)
  (205573, 'اِدراک', 'B2', 'C1'), -- perception / cognition (formal)
  (205575, 'اَلگوریتم', 'B1', 'B2'), -- algorithm (loanword)
  (205577, 'نَهر', 'B1', 'B2'), -- stream / canal (formal)
  (205582, 'نُزول', 'B2', 'C1'), -- decline / descent
  (205584, 'خُصومَت', 'B2', 'C1'), -- hostility (formal)
  (205585, 'صَریح', 'B1', 'B2'), -- explicit / direct (formal)
  (205586, 'ناعادِلانه', 'B1', 'B2'), -- unjust
  (205587, 'مُخاطِره', 'B2', 'C1'), -- risk / danger (formal)
  (205588, 'قُرآن', 'B1', 'B2'), -- the Quran
  (205592, 'مُوازی', 'B1', 'B2'), -- parallel (formal)
  (205593, 'پیش‌بینی', 'B1', 'B2'), -- prediction / forecast (پیش‌بینی کردن = to predict)
  (205594, 'پَردازَنده', 'B1', 'B2'), -- processor (formal, tech)
  (205595, 'تَضاد', 'B1', 'B2'), -- contrast / conflict (formal)
  (205596, 'تَزئین', 'B1', 'B2'), -- decoration (formal; تزئین کردن = to decorate)
  (205597, 'دِلپَذیر', 'B1', 'B2'), -- pleasant / delightful (formal)
  (205598, 'پَررو', 'B1', 'B2'), -- impudent / cheeky (informal)
  (205600, 'حَقیر', 'B2', 'C1'), -- lowly / humble (formal)
  (205601, 'مِزاج', 'B1', 'B2'), -- temperament / disposition (formal)
  (205602, 'یَقین', 'B1', 'B2'), -- certainty (formal; یقین داشتن = to be certain)
  (205603, 'بورسیه', 'B1', 'B2'), -- scholarship (loanword)
  (205604, 'تابِع', 'B1', 'B2'), -- subject; function [math] (formal)
  (205605, 'قَریب', 'B1', 'B2'), -- close / near (formal)
  (205606, 'مُتَفَرِّق', 'B2', 'C1'), -- dispersed / scattered (formal)
  (205607, 'فاتِح', 'B1', 'B2'), -- conqueror (formal)
  (205608, 'مُناظِره', 'B1', 'B2'), -- debate (formal)
  (205610, 'ضِیافَت', 'B2', 'C1'), -- banquet / feast (formal)
  (205611, 'مَعاش', 'B2', 'C1'), -- livelihood (formal)
  (205612, 'اِنتِحاری', 'B1', 'B2'), -- suicide [attack] (formal)
  (205613, 'تَحریم', 'B1', 'B2'), -- sanction / embargo (formal)
  (205614, 'خَدشه', 'B1', 'B2'), -- flaw / blemish (formal)
  (205615, 'مَحوَّل', 'B2', 'C1'), -- assigned / delegated (formal)
  (205616, 'تاخت', 'B1', 'B2'), -- gallop (تاخت و تاز = raid)
  (205617, 'راهپیمایی', 'B1', 'B2'), -- march / procession (formal)
  (205618, 'مَخلوق', 'B1', 'B2'), -- creature / creation (formal)
  (205619, 'پالس', 'B1', 'B2'), -- pulse [signal] (loanword)
  (205620, 'زَوال', 'B2', 'C1'), -- decline / decay (formal)
  (205621, 'بی‌نِهایَت', 'B1', 'B2'), -- infinite
  (205623, 'آفَت', 'B1', 'B2'), -- pest / blight; calamity (formal)
  (205624, 'کِلیشه', 'B1', 'B2'), -- cliché / stereotype (formal)
  (205626, 'اِشتِها', 'B1', 'B2'), -- appetite (formal)
  (205627, 'نافَرمانی', 'B1', 'B2'), -- disobedience (formal)
  (205628, 'غَلّات', 'B1', 'B2'), -- grains / cereals (formal)
  (205630, 'خشنود', 'B1', 'B2'), -- pleased / content (formal)
  (205631, 'رونَق', 'B1', 'B2'), -- prosperity / boom (formal)
  (205632, 'تَرغیب', 'B1', 'B2'), -- encouragement / persuasion (formal)
  (205633, 'واجِد', 'B2', 'C1'), -- possessing [a qualification] (formal)
  (205634, 'نَوسان', 'B1', 'B2'), -- fluctuation (formal)
  (205635, 'فُروتَن', 'B1', 'B2'), -- humble (formal)
  (205636, 'سَرایدار', 'B1', 'B2'), -- caretaker / janitor
  (205637, 'پیشینه', 'B1', 'B2'), -- background / history (formal)
  (205638, 'ناراضی', 'B1', 'B2'), -- dissatisfied
  (205641, 'سِرداب', 'B1', 'B2'), -- cellar / basement (formal)
  (205642, 'جَوابگو', 'B1', 'B2'), -- accountable / responsible (formal)
  (205643, 'دِلاوَر', 'B2', 'C1'), -- brave / valiant (formal)
  (205645, 'وَجهه', 'B2', 'C1'), -- reputation / image (formal)
  (205646, 'مُتَعال', 'B2', 'C1'), -- exalted / supreme (formal, religious)
  (205647, 'پژمُرده', 'B1', 'B2'), -- withered / wilted
  (205648, 'دَخیل', 'B1', 'B2'), -- involved / contributing (formal)
  (205649, 'اِطِّلاعیه', 'B1', 'B2'), -- notice / announcement (formal)
  (205650, 'دِلگَرم', 'B1', 'B2'), -- encouraged / hopeful (formal)
  (205653, 'شُکوفا', 'B1', 'B2'), -- flourishing / blooming (formal)
  (205654, 'داروغه', 'B2', 'C1'), -- sheriff / constable (historical)
  (205657, 'پیرامون', 'B1', 'B2'), -- around / regarding (formal)
  (205659, 'نِشانگَر', 'B1', 'B2'), -- indicator (formal)
  (205660, 'عَلَنی', 'B1', 'B2'), -- public / overt (formal)
  (205662, 'شیب', 'B1', 'B2'), -- slope / incline
  (205663, 'مَردود', 'B1', 'B2'), -- rejected / failed [exam] (formal)
  (205664, 'اِختیارات', 'B1', 'B2'), -- powers / authorities (formal)
  (205666, 'زَمانبَندی', 'B1', 'B2'), -- scheduling / timing (formal)
  (205669, 'تَسکین', 'B1', 'B2'), -- relief / soothing (formal; تسکین دادن = to soothe)
  (205670, 'پِدَرسوخته', 'B1', 'B2'), -- rascal / scoundrel (informal)
  (205671, 'تَقدیس', 'B2', 'C1'), -- sanctification (formal, religious)
  (205672, 'کالبُدشِکافی', 'B2', 'C1'), -- autopsy (formal, medical)
  (205674, 'بازبینی', 'B1', 'B2'), -- review / replay (formal)
  (205677, 'شِنَوایی', 'B1', 'B2'), -- hearing [sense] (formal)
  (205678, 'هَزارتو', 'B2', 'C1'), -- labyrinth / maze
  (205679, 'قافیه', 'B1', 'B2'), -- rhyme (formal, poetry)
  (205680, 'اِرجاع', 'B1', 'B2'), -- referral (formal; ارجاع دادن = to refer)
  (205681, 'بیخ', 'B2', 'C1'), -- root / base (formal)
  (205682, 'نَشاط', 'B1', 'B2'), -- vitality / joy (formal)
  (205684, 'دَغدَغه', 'B1', 'B2'), -- concern / worry (formal)
  (205685, 'تَمَنّا', 'B2', 'C1'), -- request / plea (formal; تمنا کردن = to beg)
  (205687, 'نادان', 'B1', 'B2'), -- ignorant (formal)
  (205689, 'لُکنَت', 'B1', 'B2'), -- stutter / stammer (formal)
  (205690, 'مادَرزادی', 'B2', 'C1'), -- congenital / innate (formal, medical)
  (205691, 'دَستخَط', 'B1', 'B2'), -- handwriting / signature
  (205692, 'مُنصِف', 'B1', 'B2'), -- fair / just [person] (formal)
  (205693, 'دیپلماتیک', 'B1', 'B2'), -- diplomatic (loanword)
  (205694, 'مَحبوس', 'B1', 'B2'), -- imprisoned (formal)
  (205696, 'فاکتور', 'B1', 'B2'), -- factor; invoice (loanword)
  (205697, 'کولاک', 'B1', 'B2'), -- blizzard
  (205698, 'مَسحور', 'B2', 'C1'), -- captivated / enchanted (formal)
  (205699, 'سَوق', 'B2', 'C1'), -- direction / push (formal; سوق دادن = to direct toward)
  (205700, 'تَشریح', 'B1', 'B2'), -- description / dissection (formal)
  (205701, 'دَستیابی', 'B1', 'B2'), -- achievement / attainment (formal)
  (205702, 'تَذَکُّر', 'B1', 'B2'), -- reminder / warning (formal)
  (205703, 'حَقارَت', 'B2', 'C1'), -- inferiority / humiliation (formal)
  (205704, 'قاطِع', 'B1', 'B2'), -- decisive (formal)
  (205705, 'عَمودی', 'B1', 'B2'), -- vertical (formal)
  (205706, 'مُنهَدِم', 'B2', 'C1'), -- destroyed / demolished (formal)
  (205709, 'لَغزِش', 'B1', 'B2'), -- slip / lapse (formal)
  (205710, 'گِرانِش', 'B1', 'B2'), -- gravity (physics)
  (205711, 'خَفیف', 'B1', 'B2'), -- light / mild (formal)
  (205712, 'آسفالت', 'A2', 'B1'), -- asphalt (loanword)
  (205713, 'تَبَعیَّت', 'B1', 'B2'), -- obedience / compliance (formal)
  (205714, 'اِنقِباض', 'B2', 'C1'), -- contraction (formal, medical / physics)
  (205715, 'مُتَحَیِّر', 'B2', 'C1'), -- astonished / perplexed (formal)
  (205716, 'مُتَأَثِّر', 'B1', 'B2'), -- affected / moved [emotionally] (formal)
  (205717, 'آهَنگَر', 'A2', 'B1'), -- blacksmith
  (205721, 'پارِگی', 'B1', 'B2'), -- tear / rupture (medical)
  (205722, 'بامداد', 'B2', 'C1'), -- dawn / early morning (formal, poetic)
  (205723, 'حُرمَت', 'B1', 'B2'), -- sanctity / respect (formal)
  (205724, 'مارپیچ', 'B1', 'B2'), -- spiral
  (205725, 'ققنوس', 'B1', 'B2'), -- phoenix (mythological)
  (205726, 'جَذبه', 'B1', 'B2'), -- charisma / allure (formal)
  (205727, 'اَسرارآمیز', 'B1', 'B2'), -- mysterious (formal)
  (205729, 'مِهماندار', 'A2', 'B1'), -- flight attendant / host
  (205730, 'ناچار', 'B1', 'B2'), -- compelled / having no choice (formal)
  (205731, 'غِیاب', 'B1', 'B2'), -- absence (formal)
  (205732, 'موذی', 'B2', 'C1'), -- sly / insidious (formal)
  (205733, 'غَلیظ', 'B1', 'B2'), -- thick / concentrated [liquid] (formal)
  (205734, 'تَناقُض', 'B1', 'B2'), -- contradiction (formal)
  (205735, 'سَنگدِل', 'B1', 'B2'), -- hardhearted / cruel (formal)
  (205736, 'تَنَزُّل', 'B2', 'C1'), -- decline / demotion (formal)
  (205738, 'سِحرآمیز', 'B1', 'B2'), -- magical / enchanting (formal)
  (205739, 'تاوَل', 'A2', 'B1'), -- blister
  (205741, 'هَمدَم', 'B2', 'C1'), -- companion (formal, literary)
  (205743, 'کوچ', 'B1', 'B2'), -- migration (nomadic; کوچ کردن = to migrate)
  (205746, 'تَناسُب', 'B1', 'B2'), -- proportion / fitness (formal)
  (205747, 'بَلال', 'A2', 'B1'), -- corn on the cob
  (205748, 'اورانیوم', 'B1', 'B2'), -- uranium (loanword)
  (205749, 'وَزِش', 'B1', 'B2'), -- blowing [wind] (formal)
  (205750, 'مُستَعِد', 'B1', 'B2'), -- prone / predisposed (formal)
  (205751, 'واجِب', 'B1', 'B2'), -- obligatory (formal)
  (205753, 'نِزاع', 'B1', 'B2'), -- dispute / fight (formal)
  (205754, 'حَمّال', 'B1', 'B2'), -- porter (dated occupation term)
  (205755, 'تَفتیش', 'B1', 'B2'), -- inspection / search (formal, legal)
  (205757, 'طَنز', 'B1', 'B2'), -- satire / humor (formal)
  (205759, 'مَدفون', 'B2', 'C1'), -- buried (formal)
  (205761, 'آبگوشت', 'A2', 'B1'), -- Persian meat stew
  (205762, 'قَرارگاه', 'B1', 'B2'), -- headquarters / camp (formal, military)
  (205763, 'غالِب', 'B1', 'B2'), -- dominant / prevailing (formal)
  (205764, 'حَلَبی', 'B2', 'C1'), -- tin / made of tin (formal)
  (205766, 'اِلقا', 'B2', 'C1'), -- suggestion / induction (formal)
  (205767, 'شاهرَگ', 'B2', 'C1'), -- jugular vein / main artery (formal)
  (205768, 'اُستوانه', 'B1', 'B2'), -- cylinder (formal, geometry)
  (205770, 'نامُنظَم', 'B1', 'B2'), -- irregular
  (205772, 'مَحصور', 'B2', 'C1'), -- confined / enclosed (formal)
  (205773, 'هَفتصَد', 'A1', 'A2'), -- seven hundred
  (205774, 'کُمِدین', 'B1', 'B2'), -- comedian (loanword)
  (205775, 'مُزمِن', 'B1', 'B2'), -- chronic (medical, formal)
  (205776, 'هَموار', 'B1', 'B2'), -- smooth / level (formal)
  (205778, 'هَمتا', 'B1', 'B2'), -- counterpart / equal (formal)
  (205779, 'اَندَک', 'B1', 'B2'), -- little / scanty (formal)
  (205780, 'سودمَند', 'B1', 'B2'), -- beneficial (formal)
  (205781, 'ناف', 'A2', 'B1'), -- navel
  (205782, 'حَیا', 'B1', 'B2'), -- modesty / shame (formal)
  (205783, 'صادِرات', 'B1', 'B2'), -- exports (formal)
  (205784, 'مُستَحکَم', 'B1', 'B2'), -- solid / robust (formal)
  (205785, 'طَیف', 'B1', 'B2'), -- spectrum / range (formal)
  (205786, 'هَمگان', 'B2', 'C1'), -- everyone / the public (formal)
  (205787, 'وِداع', 'B2', 'C1'), -- farewell (formal)
  (205788, 'تَواضُع', 'B1', 'B2'), -- humility (formal)
  (205790, 'هَشتصَد', 'A1', 'A2'), -- eight hundred
  (205791, 'وَصف', 'B1', 'B2'), -- description (formal; وصف کردن = to describe)
  (205792, 'یِکسَره', 'B1', 'B2'), -- continuously / straight (formal)
  (205793, 'فَرسوده', 'B1', 'B2'), -- worn out / dilapidated (formal)
  (205794, 'پیشگیری', 'B1', 'B2'), -- prevention (formal; پیشگیری کردن = to prevent)
  (205795, 'زیان', 'B1', 'B2'), -- loss / damage (formal)
  (205796, 'نَعره', 'B1', 'B2'), -- roar / shout (formal; نعره زدن = to roar)
  (205798, 'گُمنام', 'B1', 'B2'), -- anonymous / unknown [famous]
  (205799, 'مَحفوظ', 'B1', 'B2'), -- preserved / reserved (formal)
  (205800, 'دامپِزِشک', 'A2', 'B1'), -- veterinarian
  (205801, 'لَبریز', 'B1', 'B2'), -- overflowing (formal)
  (205802, 'میانگین', 'B1', 'B2'), -- average / mean (formal, statistics)
  (205803, 'تِلیام', 'B2', 'C1'), -- healing / relief (formal)
  (205804, 'شُهود', 'B2', 'C1'), -- witnesses / testimony (formal, legal)
  (205805, 'دَخمه', 'B2', 'C1'), -- crypt / dungeon (formal)
  (205806, 'مَردُمَک', 'B1', 'B2'), -- pupil [eye] (formal, medical)
  (205807, 'سَهمیه', 'B1', 'B2'), -- quota (formal)
  (205808, 'موثَّق', 'B2', 'C1'), -- reliable / authentic (formal)
  (205809, 'اِختِلاس', 'B1', 'B2'), -- embezzlement (formal, legal)
  (205810, 'حیطه', 'B1', 'B2'), -- domain / scope (formal)
  (205811, 'مَترَسَک', 'A2', 'B1'), -- scarecrow
  (205812, 'آرامگاه', 'B1', 'B2'), -- mausoleum / tomb (formal)
  (205814, 'حَتمی', 'B1', 'B2'), -- certain / definite (formal)
  (205815, 'پَهلوی', 'B1', 'B2'), -- beside / next to
  (205816, 'نَزاکَت', 'B2', 'C1'), -- politeness / decorum (formal)
  (205817, 'شِلَنگ', 'A2', 'B1'), -- hose
  (205818, 'بیولوژیکی', 'B1', 'B2'), -- biological
  (205819, 'خَبیث', 'B1', 'B2'), -- malicious / wicked (formal)
  (205820, 'سِندرُم', 'B1', 'B2'), -- syndrome (loanword, medical)
  (205821, 'عُروق', 'B2', 'C1'), -- blood vessels (formal, medical)
  (205822, 'داشبورد', 'A2', 'B1'), -- dashboard [car] (loanword)
  (205823, 'جِسمانی', 'B1', 'B2'), -- physical / bodily (formal)
  (205824, 'اِقلیم', 'B1', 'B2'), -- climate / region (formal)
  (205825, 'بَصیرَت', 'B2', 'C1'), -- insight / foresight (formal)
  (205826, 'غُرفه', 'B1', 'B2'), -- booth / stall (exhibition)
  (205827, 'ایفا', 'B1', 'B2'), -- performance / fulfillment (formal; ایفا کردن = to fulfill [a role])
  (205828, 'کارناوال', 'A2', 'B1'), -- carnival (loanword)
  (205829, 'شامپانزه', 'A2', 'B1'), -- chimpanzee (loanword)
  (205830, 'عَصربِخِیر', 'A1', 'A2'), -- good afternoon
  (205831, 'تِراکتور', 'A2', 'B1'), -- tractor (loanword)
  (205832, 'باطِن', 'B2', 'C1'), -- inner self / essence (formal)
  (205833, 'آلزایمر', 'B1', 'B2'), -- Alzheimer's (loanword, medical)
  (205835, 'اَنباشته', 'B1', 'B2'), -- accumulated / stockpiled (formal)
  (205836, 'مَصلَحَت', 'B2', 'C1'), -- expediency / advisability (formal)
  (205837, 'خَندَق', 'B2', 'C1'), -- moat / trench (formal, historical)
  (205838, 'شیطَنَت', 'B1', 'B2'), -- mischief (formal)
  (205839, 'رَگبار', 'B1', 'B2'), -- downpour / burst of gunfire (formal)
  (205840, 'اِشتِعال', 'B2', 'C1'), -- ignition / combustion (formal, technical)
  (205844, 'غیرطَبیعی', 'B1', 'B2'), -- abnormal
  (205845, 'تِلِسکوپ', 'A2', 'B1'), -- telescope (loanword)
  (205846, 'بَرآمَدگی', 'B1', 'B2'), -- bulge / protrusion (formal)
  (205847, 'چارچوب', 'B1', 'B2'), -- framework / frame
  (205848, 'اِنحِصاری', 'B1', 'B2'), -- exclusive (formal)
  (205849, 'عارِضه', 'B1', 'B2'), -- side effect / complication (formal, medical)
  (205850, 'کارکَرد', 'B1', 'B2'), -- function / performance (formal)
  (205851, 'دَربان', 'A2', 'B1'), -- doorman / gatekeeper
  (205852, 'هِفدَهُم', 'A2', 'B1'), -- seventeenth
  (205853, 'بَدرَقه', 'B1', 'B2'), -- farewell / send-off (formal)
  (205854, 'کاهو', 'A1', 'A2'), -- lettuce
  (205855, 'عامّه', 'B1', 'B2'), -- the public / masses (formal)
  (205856, 'مُهلِک', 'B1', 'B2'), -- fatal / lethal (formal)
  (205857, 'رَدپا', 'A2', 'B1'), -- footprint / trace
  (205858, 'مُختَص', 'B1', 'B2'), -- exclusive to / specific to (formal)
  (205859, 'نُهصَد', 'A1', 'A2'), -- nine hundred
  (205860, 'کتیبه', 'B1', 'B2'), -- inscription (formal, archaeology)
  (205861, 'مُنزَوی', 'B1', 'B2'), -- isolated / reclusive (formal)
  (205863, 'پَرهیز', 'B1', 'B2'), -- abstinence / avoidance (formal; پرهیز کردن = to abstain)
  (205864, 'خَسیس', 'B1', 'B2'), -- stingy / miserly
  (205866, 'تَخَطّی', 'B2', 'C1'), -- violation / transgression (formal)
  (205867, 'ستیز', 'B1', 'B2'), -- conflict / strife (formal)
  (205868, 'گوگِرد', 'A2', 'B1'), -- sulfur (chemistry)
  (205869, 'تَوبیخ', 'B1', 'B2'), -- reprimand (formal; توبیخ کردن = to reprimand)
  (205870, 'اَقَلّیَّت', 'B1', 'B2'), -- minority (formal)
  (205871, 'دِلداری', 'B1', 'B2'), -- comforting / consolation (formal; دلداری دادن = to comfort)
  (205872, 'ناشِر', 'B1', 'B2'), -- publisher (formal)
  (205873, 'کتابچه', 'A2', 'B1'), -- booklet
  (205874, 'جِلبَک', 'A2', 'B1'), -- algae / seaweed
  (205875, 'وَهم', 'B1', 'B2'), -- illusion / delusion (formal)
  (205876, 'بُزغاله', 'A2', 'B1'), -- kid [baby goat]
  (205877, 'لاکپُشت', 'A1', 'A2'), -- turtle
  (205878, 'قَبیل', 'B1', 'B2'), -- kind / type (formal)
  (205879, 'مَنشَأ', 'B1', 'B2'), -- origin / source (formal)
  (205880, 'خَفِگی', 'B1', 'B2'), -- suffocation (formal)
  (205881, 'جَسور', 'B1', 'B2'), -- bold / daring (formal)
  (205882, 'قِشر', 'B1', 'B2'), -- class / stratum (formal, social)
  (205883, 'طِب', 'B1', 'B2'), -- medicine [field] (formal)
  (205884, 'شاخِص', 'B1', 'B2'), -- index / indicator (formal)
  (205886, 'دَکّه', 'A2', 'B1'), -- kiosk / stall
  (205887, 'مُتَواضِع', 'B1', 'B2'), -- humble (formal)
  (205888, 'پوزخَند', 'B1', 'B2'), -- smirk / sneer
  (205889, 'اِستِتار', 'B2', 'C1'), -- camouflage (formal, military)
  (205891, 'غَضَب', 'B2', 'C1'), -- wrath / anger (formal)
  (205892, 'مُحتَویات', 'B1', 'B2'), -- contents (formal)
  (205893, 'سِرکه', 'A2', 'B1'), -- vinegar
  (205894, 'پارادوکس', 'B1', 'B2'), -- paradox (loanword)
  (205895, 'مُمانِعَت', 'B2', 'C1'), -- prevention / obstruction (formal)
  (205896, 'هِکتار', 'A2', 'B1'), -- hectare (loanword)
  (205897, 'فَرابَنَفش', 'B2', 'C1'), -- ultraviolet (formal, physics)
  (205899, 'هِجّی', 'B1', 'B2'), -- spelling (formal; هجی کردن = to spell)
  (205900, 'کادِر', 'B1', 'B2'), -- staff / cadre (loanword)
  (205901, 'کَفتار', 'A2', 'B1'), -- hyena
  (205902, 'اِلِکترومَغناطیسی', 'B2', 'C1'), -- electromagnetic (formal, physics)
  (205903, 'آزُرده', 'B1', 'B2'), -- hurt / offended (formal)
  (205905, 'خِردمَند', 'B1', 'B2'), -- wise (formal)
  (205907, 'نارِسایی', 'B1', 'B2'), -- insufficiency / failure (formal, medical)
  (205908, 'هِجدَهُم', 'A2', 'B1'), -- eighteenth
  (205909, 'قَدبُلَند', 'A2', 'B1'), -- tall
  (205910, 'بُزُرگداشت', 'B1', 'B2'), -- commemoration (formal)
  (205911, 'مُسَبِّب', 'B2', 'C1'), -- cause / culprit (formal)
  (205912, 'هَندَسه', 'B1', 'B2'), -- geometry (formal)
  (205913, 'مُنکِر', 'B1', 'B2'), -- denying / denier (formal)
  (205914, 'ضَرورَت', 'B1', 'B2'), -- necessity (formal)
  (205915, 'دِلبَر', 'B2', 'C1'), -- beloved / charmer (formal, poetic)
  (205916, 'صَرفِنَظَر', 'B1', 'B2'), -- disregard (formal; صرفنظر کردن = to disregard)
  (205917, 'غوغا', 'B1', 'B2'), -- uproar / commotion (formal)
  (205918, 'مُتِوَسِّل', 'B2', 'C1'), -- resorting to (formal)
  (205919, 'مُتِزَلزِل', 'B1', 'B2'), -- shaky / unstable (formal)
  (205920, 'تَدریج', 'B1', 'B2'), -- gradualness (formal; به تدریج = gradually)
  (205921, 'نَخاله', 'B1', 'B2'), -- rubble / debris
  (205922, 'بادبادَک', 'A1', 'A2'), -- kite [toy]
  (205923, 'اِنشِعاب', 'B2', 'C1'), -- branching / split (formal)
  (205924, 'پَدید', 'B1', 'B2'), -- apparent / manifest (formal; پدید آمدن = to come into being)
  (205925, 'طَرَفین', 'B1', 'B2'), -- both sides / parties (formal, legal)
  (205926, 'رَقیق', 'B1', 'B2'), -- diluted / thin [liquid] (formal)
  (205927, 'بودایی', 'B1', 'B2'), -- Buddhist
  (205928, 'آنزیم', 'B1', 'B2'), -- enzyme (chemistry, loanword)
  (205929, 'دیکتاتور', 'B1', 'B2'), -- dictator (loanword)
  (205930, 'اَنگ', 'B1', 'B2'), -- stigma / brand (formal; انگ زدن = to stigmatize)
  (205931, 'شَفَقَت', 'B1', 'B2'), -- compassion (formal)
  (205932, 'جُزوه', 'B1', 'B2'), -- pamphlet / handout (academic)
  (205933, 'خُرافات', 'B1', 'B2'), -- superstitions (formal)
  (205934, 'دَستاوَرد', 'B1', 'B2'), -- achievement (formal)
  (205935, 'زُمُرُّد', 'A2', 'B1'), -- emerald (gemstone)
  (205936, 'باراَنداز', 'B1', 'B2'), -- dock / loading dock
  (205937, 'نِژادپَرَست', 'B1', 'B2'), -- racist
  (205938, 'بَرخوردار', 'B2', 'C1'), -- possessing / enjoying [benefits] (formal)
  (205940, 'داروسازی', 'B1', 'B2'), -- pharmacy [profession]
  (205941, 'مَرمَر', 'A2', 'B1'), -- marble [stone]
  (205942, 'راستگو', 'B1', 'B2'), -- truthful / honest
  (205943, 'خوردِگی', 'B1', 'B2'), -- corrosion / erosion (formal)
  (205944, 'خَلسه', 'B2', 'C1'), -- trance (formal)
  (205945, 'شَلوارَک', 'A2', 'B1'), -- shorts [clothing]
  (205946, 'تَشبیه', 'B1', 'B2'), -- simile / comparison (formal, literary)
  (205947, 'عَزم', 'B1', 'B2'), -- determination / resolve (formal)
  (205948, 'دَنج', 'B1', 'B2'), -- cozy (informal)
  (205949, 'هَمکَف', 'B1', 'B2'), -- ground floor (formal)
  (205950, 'زودرَس', 'B1', 'B2'), -- premature / early (formal)
  (205951, 'تَعَفُّن', 'B2', 'C1'), -- stench (formal)
  (205953, 'مُتَشَخِّص', 'B1', 'B2'), -- distinguished / notable (formal)
  (205954, 'دارَنده', 'B1', 'B2'), -- holder / bearer (formal)
  (205955, 'اِزدِحام', 'B1', 'B2'), -- crowding / congestion (formal)
  (205956, 'تاجگُذاری', 'B2', 'C1'), -- coronation (formal, historical)
  (205957, 'هَمخونی', 'B1', 'B2'), -- compatibility / blood relation (formal)
  (205960, 'دَمدَمی', 'B1', 'B2'), -- moody / capricious (informal)
  (205961, 'زَرافه', 'A1', 'A2'), -- giraffe
  (205962, 'یگانه', 'B2', 'C1'), -- unique / singular (formal, literary)
  (205963, 'اَواسِط', 'B1', 'B2'), -- middle / mid- (formal)
  (205964, 'گَندیده', 'B1', 'B2'), -- rotten / decayed (formal)
  (205965, 'راوی', 'B1', 'B2'), -- narrator (formal)
  (205966, 'هَدفون', 'A2', 'B1'), -- headphones (loanword)
  (205967, 'حَواله', 'B1', 'B2'), -- remittance / money transfer (formal)
  (205968, 'قاصِد', 'B1', 'B2'), -- messenger (formal)
  (205969, 'شایِع', 'B1', 'B2'), -- widespread / common [rumor / disease] (formal)
  (205970, 'مَرسوم', 'B1', 'B2'), -- customary / conventional (formal)
  (205971, 'قوز', 'B1', 'B2'), -- hump / hunchback (formal)
  (205972, 'تَحریر', 'B1', 'B2'), -- writing / composition (formal)
  (205973, 'واردات', 'B1', 'B2'), -- imports (formal)
  (205974, 'مَعیوب', 'B1', 'B2'), -- defective (formal)
  (205975, 'رازداری', 'B1', 'B2'), -- discretion / secrecy (formal)
  (205978, 'سَعودی', 'A2', 'B1'), -- Saudi (nationality)
  (205980, 'دِراماتیک', 'B1', 'B2'), -- dramatic (loanword)
  (205981, 'مَقصود', 'B1', 'B2'), -- intention / purpose (formal)
  (205982, 'نِجوا', 'B1', 'B2'), -- whisper (formal; نجوا کردن = to whisper)
  (205983, 'کائِنات', 'B2', 'C1'), -- the cosmos / universe (formal)
  (205984, 'عابِر', 'B1', 'B2'), -- pedestrian (formal)
  (205986, 'لاشخور', 'A2', 'B1'), -- vulture
  (205987, 'مُرتَفِع', 'B2', 'C1'), -- elevated / high (formal)
  (205988, 'پَرخاشگَر', 'B1', 'B2'), -- aggressive (formal)
  (205989, 'اِسفَنجی', 'A2', 'B1'), -- spongy (formal)
  (205990, 'شَناسنامه', 'A2', 'B1'), -- birth certificate / ID document
  (205991, 'کَسر', 'B1', 'B2'), -- deduction / fraction (formal)
  (205992, 'خودسَر', 'B1', 'B2'), -- headstrong / self-willed (formal)
  (205993, 'مَنظَر', 'B1', 'B2'), -- view / vista; perspective (formal)
  (205994, 'اِنعِقاد', 'B2', 'C1'), -- convening; coagulation (formal)
  (205995, 'سِمینار', 'A2', 'B1'), -- seminar (loanword)
  (205996, 'دوستدار', 'B1', 'B2'), -- admirer / well-wisher (formal)
  (205997, 'فِلَسطینی', 'A2', 'B1'), -- Palestinian (nationality)
  (205998, 'رادیواَکتیو', 'B1', 'B2'), -- radioactive (loanword)
  (205999, 'رَستاخیز', 'B2', 'C1'), -- resurrection (formal / religious)
  (206000, 'بازپَروَری', 'B1', 'B2'), -- rehabilitation (formal)
  (206001, 'پیشرَو', 'B1', 'B2'), -- pioneer / leading (formal)
  (206002, 'مَنگَنه', 'A2', 'B1'), -- stapler
  (206003, 'خواستگار', 'B1', 'B2'), -- suitor
  (206005, 'اِنضِباط', 'B1', 'B2'), -- discipline (formal)
  (206006, 'آهَنرُبا', 'A2', 'B1'), -- magnet
  (206007, 'لاما', 'A2', 'B1'), -- llama (loanword)
  (206008, 'قابلمه', 'A2', 'B1'), -- pot [cooking]
  (206009, 'چَسبناک', 'B1', 'B2'), -- sticky
  (206010, 'حَماسه', 'B1', 'B2'), -- epic (formal, literary)
  (206011, 'سیاهچال', 'B1', 'B2'), -- dungeon; black hole
  (206012, 'بارگاه', 'B2', 'C1'), -- court / threshold (formal, historical)
  (206013, 'اِنتِشارات', 'B1', 'B2'), -- publications (formal)
  (206014, 'ضارِب', 'B2', 'C1'), -- attacker / assailant (formal, legal)
  (206015, 'شَکّاک', 'B1', 'B2'), -- skeptical (formal)
  (206016, 'عَقلانی', 'B1', 'B2'), -- rational (formal)
  (206017, 'وُلتاژ', 'A2', 'B1'), -- voltage (loanword)
  (206018, 'پتاسیم', 'A2', 'B1'), -- potassium (chemistry, loanword)
  (206019, 'بازپَرداخت', 'B1', 'B2'), -- repayment (formal, financial)
  (206020, 'فَناناپَذیر', 'B2', 'C1'), -- indestructible / immortal (formal)
  (206021, 'خَلاء', 'B1', 'B2'), -- vacuum / void (formal, physics)
  (206022, 'اَغتِشاش', 'B2', 'C1'), -- disturbance / riot (formal)
  (206023, 'بازدارَنده', 'B1', 'B2'), -- deterrent (formal)
  (206024, 'میگرِن', 'B1', 'B2'), -- migraine (loanword)
  (206026, 'دَریانَوَردی', 'B1', 'B2'), -- seafaring / navigation (formal)
  (206027, 'غَوّاص', 'A2', 'B1'), -- diver
  (206028, 'شُخم', 'B1', 'B2'), -- plowing (شخم زدن = to plow)
  (206029, 'تَطهیر', 'B2', 'C1'), -- purification (formal, religious)
  (206030, 'نُخاع', 'B1', 'B2'), -- spinal cord (medical)
  (206031, 'گوشزَد', 'B1', 'B2'), -- reminder / warning (formal; گوشزد کردن = to remind)
  (206033, 'مُخابِرات', 'B1', 'B2'), -- telecommunications (formal)
  (206034, 'مَتروک', 'B1', 'B2'), -- abandoned (formal)
  (206035, 'ضَمیمه', 'B1', 'B2'), -- attachment / appendix (formal)
  (206036, 'تَکثیر', 'B1', 'B2'), -- reproduction / multiplication (formal)
  (206037, 'لیره', 'A2', 'B1'), -- lira [currency] (loanword)
  (206038, 'سَبقَت', 'B1', 'B2'), -- overtaking (formal; سبقت گرفتن = to overtake)
  (206039, 'سَنجِش', 'B1', 'B2'), -- measurement / assessment (formal)
  (206040, 'تَضعیف', 'B2', 'C1'), -- weakening (formal; تضعیف کردن = to weaken)
  (206041, 'رُخداد', 'B1', 'B2'), -- event / occurrence (formal)
  (206042, 'فُروکِش', 'B1', 'B2'), -- subsiding (formal; فروکش کردن = to subside)
  (206045, 'قَوس', 'B1', 'B2'), -- arc / curve (formal, geometry)
  (206046, 'مالاریا', 'A2', 'B1'), -- malaria (loanword)
  (206047, 'کَفّاره', 'B2', 'C1'), -- atonement (formal, religious)
  (206048, 'خَلیفه', 'B1', 'B2'), -- caliph (historical / religious title)
  (206049, 'زالو', 'A2', 'B1'), -- leech
  (206050, 'ائتِلاف', 'B1', 'B2'), -- coalition (formal, political)
  (206051, 'راسِخ', 'B2', 'C1'), -- firm / resolute (formal)
  (206052, 'بازنویسی', 'B1', 'B2'), -- rewriting (formal)
  (206054, 'اَیّام', 'B2', 'C1'), -- days (formal)
  (206055, 'زِمُخت', 'B1', 'B2'), -- rough / coarse (formal)
  (206056, 'کُنسولگَری', 'B1', 'B2'), -- consulate (formal)
  (206057, 'مُعاوَنَت', 'B1', 'B2'), -- deputy position / vice-presidency (formal)
  (206058, 'مِژه', 'A2', 'B1'), -- eyelash
  (206059, 'هارمونی', 'A2', 'B1'), -- harmony (loanword)
  (206060, 'تِهی', 'B2', 'C1'), -- empty (formal, literary)
  (206061, 'رَمزگُذاری', 'B1', 'B2'), -- encryption (formal)
  (206062, 'مُوَظَّف', 'B1', 'B2'), -- obligated (formal)
  (206063, 'اَصالَت', 'B1', 'B2'), -- authenticity / origin (formal)
  (206064, 'مُکَرَّر', 'B1', 'B2'), -- repeated (formal)
  (206065, 'سِرایَت', 'B1', 'B2'), -- contagion / spreading (formal, medical)
  (206066, 'بیزار', 'B1', 'B2'), -- disgusted / averse (formal)
  (206067, 'اَفاده', 'B1', 'B2'), -- pretension / showing off (informal)
  (206068, 'خونخوار', 'B1', 'B2'), -- bloodthirsty (formal)
  (206069, 'نامَفهوم', 'B1', 'B2'), -- incomprehensible (formal)
  (206070, 'مُتِکَبِّر', 'B1', 'B2'), -- arrogant (formal)
  (206071, 'مابین', 'B1', 'B2'), -- between (formal)
  (206072, 'سَمِج', 'B1', 'B2'), -- persistent / stubborn (informal)
  (206073, 'عود', 'B1', 'B2'), -- relapse / recurrence [medical] (formal)
  (206074, 'خَشخاش', 'A2', 'B1'), -- poppy (plant)
  (206075, 'مُناقِصه', 'B2', 'C1'), -- tender / bid (formal, business)
  (206077, 'پیشانی', 'A2', 'B1'), -- forehead
  (206078, 'مَنصَب', 'B1', 'B2'), -- position / post (formal)
  (206079, 'شَمش', 'B1', 'B2'), -- ingot / bar [gold]
  (206080, 'خُروپُف', 'A2', 'B1'), -- snoring (خروپف کردن = to snore)
  (206081, 'مُتَوالی', 'B1', 'B2'), -- consecutive (formal)
  (206082, 'تَساوی', 'B1', 'B2'), -- equality / tie [sports] (formal)
  (206083, 'دانایی', 'B1', 'B2'), -- knowledge / wisdom (formal)
  (206086, 'هَمخانه', 'A2', 'B1'), -- roommate
  (206087, 'پَنکه', 'A2', 'B1'), -- fan [electric]
  (206090, 'مَشروع', 'B1', 'B2'), -- legitimate (formal)
  (206091, 'کاراکتِر', 'A2', 'B1'), -- character (loanword, fiction)
  (206092, 'شُبهه', 'B1', 'B2'), -- doubt / suspicion (formal)
  (206093, 'دَبیر', 'B1', 'B2'), -- teacher / secretary (formal)
  (206094, 'تیروئید', 'B1', 'B2'), -- thyroid (loanword, medical)
  (206095, 'کَسری', 'B1', 'B2'), -- deficit / shortage (formal)
  (206096, 'اَتکا', 'B1', 'B2'), -- reliance (formal; اتکا کردن = to rely)
  (206097, 'جِفتَک', 'B1', 'B2'), -- kick [animal] (informal)
  (206098, 'سِلحِشور', 'B2', 'C1'), -- warrior / knight (formal, literary)
  (206099, 'پیشگاه', 'B2', 'C1'), -- presence / threshold (formal, honorific)
  (206100, 'قَمه', 'B1', 'B2'), -- large knife / machete
  (206101, 'اِفراط', 'B1', 'B2'), -- excess / extremism (formal)
  (206102, 'مُختَرِع', 'B1', 'B2'), -- inventor (formal)
  (206103, 'مُتَشَکِّل', 'B2', 'C1'), -- composed of / consisting of (formal)
  (206104, 'سَردَر', 'B1', 'B2'), -- entrance / gate (formal, architecture)
  (206105, 'شِکلَک', 'A2', 'B1'), -- grimace / emoji (informal)
  (206106, 'نِسبیَّت', 'B1', 'B2'), -- relativity (formal, physics)
  (206107, 'اِستِقرار', 'B1', 'B2'), -- establishment / deployment (formal)
  (206108, 'چانه', 'A2', 'B1'), -- chin; bargaining
  (206109, 'کُنونی', 'B1', 'B2'), -- current / present (formal)
  (206110, 'قِلقِلَک', 'A2', 'B1'), -- tickle (قلقلک دادن = to tickle)
  (206111, 'مُجرِمانه', 'B1', 'B2'), -- criminal [adjective] (formal)
  (206112, 'مُتَوَرِّم', 'B1', 'B2'), -- swollen (formal, medical)
  (206113, 'کِشیک', 'B1', 'B2'), -- shift / watch [duty] (formal)
  (206114, 'مُتَمایِز', 'B1', 'B2'), -- distinct (formal)
  (206115, 'جامِد', 'B1', 'B2'), -- solid [state of matter] (formal, physics)
  (206116, 'سَلب', 'B2', 'C1'), -- deprivation / revocation (formal, legal)
  (206117, 'ریسمان', 'B1', 'B2'), -- rope / cord (formal)
  (206118, 'هَمرَنگ', 'B1', 'B2'), -- same color / conforming (formal)
  (206119, 'مُعتَرِف', 'B1', 'B2'), -- confessing (formal)
  (206120, 'مُدیرعامِل', 'B1', 'B2'), -- CEO / managing director
  (206121, 'اُعجوبه', 'B2', 'C1'), -- prodigy / genius (formal)
  (206122, 'هَشتُمین', 'A2', 'B1'), -- eighth
  (206123, 'طاقچه', 'A2', 'B1'), -- alcove / niche [wall shelf]
  (206124, 'سَهل', 'B2', 'C1'), -- easy (formal, literary)
  (206125, 'آلونَک', 'B1', 'B2'), -- shack / hut
  (206126, 'اِبهام', 'B1', 'B2'), -- ambiguity (formal)
  (206127, 'گُفتار', 'B1', 'B2'), -- speech / discourse (formal)
  (206128, 'ضایِعه', 'B1', 'B2'), -- injury / damage (formal, medical)
  (206129, 'نِشانگان', 'B2', 'C1'), -- syndrome / symptoms (formal, medical)
  (206130, 'لاپوشانی', 'B1', 'C1'), -- cover-up (informal)
  (206131, 'قَمَر', 'B1', 'B2'), -- moon / satellite (formal, celestial)
  (206132, 'حِسابرَسی', 'B1', 'B2'), -- auditing (formal)
  (206133, 'مَنسوخ', 'B1', 'B2'), -- obsolete (formal)
  (206134, 'نَسَب', 'B1', 'B2'), -- lineage / descent (formal)
  (206135, 'هَذیان', 'B1', 'B2'), -- delirium / raving (formal, medical)
  (206137, 'اِصلاحیه', 'B1', 'B2'), -- amendment (formal, legal)
  (206138, 'نَعل', 'A2', 'B1'), -- horseshoe
  (206139, 'مُدارا', 'B1', 'B2'), -- tolerance / leniency (formal; مدارا کردن = to be tolerant)
  (206140, 'دیپلمات', 'A2', 'B1'), -- diplomat (loanword)
  (206141, 'دَهانه', 'B1', 'B2'), -- mouth / opening [of river, cave] (formal)
  (206142, 'کَتبی', 'B1', 'B2'), -- written / in writing (formal)
  (206143, 'اُختاپوس', 'A2', 'B1'), -- octopus (loanword)
  (206144, 'بارَور', 'B1', 'B2'), -- fertile (formal)
  (206145, 'تَعدیل', 'B1', 'B2'), -- adjustment / moderation (formal)
  (206146, 'اِستِنشاق', 'B2', 'C1'), -- inhalation (formal, medical)
  (206147, 'گُروهَک', 'B2', 'C1'), -- small group / faction (formal, derogatory political)
  (206148, 'میکروسکوپ', 'A2', 'B1'), -- microscope (loanword)
  (206149, 'اِکران', 'B1', 'B2'), -- screening [movie] (formal)
  (206150, 'ضِلع', 'A2', 'B1'), -- side [geometry] (formal)
  (206151, 'تَبلِت', 'A2', 'B1'), -- tablet [device] (loanword)
  (206152, 'عَهدنامه', 'B1', 'B2'), -- treaty document (formal)
  (206153, 'عَلاف', 'B1', 'B2'), -- unemployed / loafing (informal)
  (206154, 'اِنبِساط', 'B2', 'C1'), -- expansion (formal, physics)
  (206155, 'عُثمانی', 'B2', 'C1'), -- Ottoman (historical)
  (206156, 'اِظهارنامه', 'B2', 'C1'), -- declaration form (formal, legal / tax)
  (206157, 'مُنطَبِق', 'B1', 'B2'), -- conforming / consistent (formal)
  (206158, 'صُدور', 'B1', 'B2'), -- issuance (formal)
  (206159, 'کَسالَت', 'B1', 'B2'), -- malaise / boredom (formal)
  (206160, 'گورکَن', 'B1', 'B2'), -- gravedigger
  (206161, 'فَرجام', 'B2', 'C1'), -- outcome / ending (formal, literary)
  (206162, 'تَسریع', 'B1', 'B2'), -- acceleration / expediting (formal)
  (206163, 'مُغول', 'B2', 'C1'), -- Mongol (historical)
  (206164, 'جِهیزیه', 'B1', 'B2'), -- dowry / trousseau
  (206165, 'نَظَرسَنجی', 'B1', 'B2'), -- poll / survey (formal)
  (206166, 'تَنظیمات', 'B1', 'B2'), -- settings (formal)
  (206167, 'اُرگان', 'B1', 'B2'), -- organ [organization / body] (loanword)
  (206168, 'بازدِه', 'B1', 'B2'), -- yield / output (formal, economics)
  (206169, 'جیرجیرَک', 'A2', 'B1'), -- cricket [insect]
  (206170, 'شَجَره', 'B2', 'C1'), -- lineage / family tree (formal)
  (206171, 'پُشتوانه', 'B1', 'B2'), -- backing / support [financial] (formal)
  (206172, 'مُسالِمَت', 'B2', 'C1'), -- peacefulness (formal)
  (206173, 'زیرپوش', 'A2', 'B1'), -- undershirt
  (206174, 'دِلهُره', 'B1', 'B2'), -- anxiety / dread (formal)
  (206175, 'نامادَری', 'A2', 'B1'), -- stepmother
  (206176, 'رَعیَّت', 'B2', 'C1'), -- peasant / subject [historical] (formal)
  (206177, 'اِستِناد', 'B2', 'C1'), -- citing / reference (formal, legal / academic)
  (206178, 'پولشویی', 'B1', 'B2'), -- money laundering (formal)
  (206179, 'شَیّاد', 'B1', 'B2'), -- swindler / con artist (formal)
  (206180, 'زیردَست', 'B1', 'B2'), -- subordinate (formal)
  (206181, 'شَبنَم', 'A2', 'B1'), -- dew
  (206182, 'ذائِقه', 'B1', 'B2'), -- taste / palate (formal)
  (206183, 'اِسفَنج', 'A2', 'B1'), -- sponge
  (206184, 'پیامَد', 'B1', 'B2'), -- consequence (formal)
  (206185, 'مولِد', 'B1', 'B2'), -- generator / source (formal)
  (206186, 'مُعَذَّب', 'B1', 'B2'), -- uncomfortable / embarrassed (formal)
  (206187, 'غَرَض', 'B1', 'B2'), -- purpose / malice (formal)
  (206188, 'ضَخامَت', 'B1', 'B2'), -- thickness (formal)
  (206190, 'تَلقین', 'B1', 'B2'), -- suggestion / indoctrination (formal)
  (206191, 'اِشباع', 'B2', 'C1'), -- saturation (formal, chemistry / psychology)
  (206192, 'پُرفُروش', 'B1', 'B2'), -- bestselling (formal)
  (206193, 'خُرخون', 'A2', 'B1'), -- bookworm / nerd (informal)
  (206194, 'آرواره', 'B1', 'B2'), -- jaw (formal, anatomical)
  (206195, 'شَناگَر', 'A2', 'B1'), -- swimmer
  (206196, 'سُنجاقَک', 'A2', 'B1'), -- dragonfly
  (206197, 'ناممکِن', 'B1', 'B2'), -- impossible
  (206198, 'مُتِناوِب', 'B1', 'B2'), -- alternating / periodic (formal)
  (206199, 'اِستِحکام', 'B1', 'B2'), -- solidity / strength (formal)
  (206200, 'جَبر', 'B1', 'B2'), -- algebra
  (206202, 'تَفکیک', 'B1', 'B2'), -- separation / segregation (formal)
  (206203, 'مَهیب', 'B2', 'C1'), -- dreadful / terrifying (formal)
  (206204, 'اِستراتِژیک', 'B1', 'B2'), -- strategic (loanword)
  (206205, 'نیترات', 'A2', 'B1'), -- nitrate (chemistry, loanword)
  (206206, 'کاتالوگ', 'A2', 'B1'), -- catalog (loanword)
  (206208, 'عاری', 'B1', 'B2'), -- devoid / free of (formal)
  (206209, 'گاومیش', 'A2', 'B1'), -- buffalo
  (206210, 'آئورت', 'B2', 'C1'), -- aorta (medical, loanword)
  (206211, 'مُرشِد', 'B2', 'C1'), -- spiritual guide / mentor (formal)
  (206212, 'سَراب', 'B1', 'B2'), -- mirage (formal)
  (206213, 'دارچین', 'A1', 'A2'), -- cinnamon
  (206214, 'تَعَرُّض', 'B2', 'C1'), -- assault / aggression (formal, legal)
  (206215, 'عاج', 'A2', 'B1'), -- ivory
  (206216, 'اِحتِراق', 'B2', 'C1'), -- combustion (formal, chemistry)
  (206217, 'ناپایدار', 'B1', 'B2'), -- unstable
  (206218, 'پیشاهَنگ', 'B1', 'B2'), -- scout / pioneer (formal)
  (206219, 'بَدگُمان', 'B1', 'B2'), -- suspicious / distrustful (formal)
  (206220, 'مَجارِستانی', 'A2', 'B1'), -- Hungarian (nationality)
  (206221, 'عَموزاده', 'A2', 'B1'), -- cousin (paternal uncle's child)
  (206222, 'بُنیانگُذار', 'B1', 'B2'), -- founder (formal)
  (206223, 'بَیانگَر', 'B1', 'B2'), -- indicative of / representing (formal)
  (206224, 'دِلنِشین', 'B1', 'B2'), -- pleasant / charming (formal)
  (206225, 'هَلاک', 'B1', 'B2'), -- death / perishing (formal)
  (206226, 'اِلِکترون', 'A2', 'B1'), -- electron (loanword)
  (206227, 'غُلام', 'B1', 'B2'), -- servant / slave [historical] (formal)
  (206228, 'تَجَمُّلی', 'B1', 'B2'), -- luxurious (formal)
  (206229, 'پَهناوَر', 'B1', 'B2'), -- vast / extensive (formal)
  (206230, 'دَرج', 'B1', 'B2'), -- insertion / recording (formal)
  (206231, 'خوشبین', 'B1', 'B2'), -- optimistic (formal)
  (206232, 'فَراخوان', 'B1', 'B2'), -- call / summons (formal)
  (206233, 'جانانه', 'B2', 'C1'), -- vigorously / wholeheartedly (formal)
  (206234, 'عامیانه', 'B1', 'B2'), -- colloquial / vernacular (formal)
  (206235, 'پیمانه', 'A2', 'B1'), -- measure / portion (cooking)
  (206236, 'ناگُفته', 'B1', 'B2'), -- unsaid / untold (formal)
  (206237, 'کَلسیم', 'A2', 'B1'), -- calcium (chemistry, loanword)
  (206238, 'مَشَقَّت', 'B2', 'C1'), -- hardship (formal)
  (206239, 'عاجِز', 'B1', 'B2'), -- helpless / incapable (formal)
  (206240, 'کِشتیرانی', 'B1', 'B2'), -- shipping / navigation (formal)
  (206241, 'مُچاله', 'B1', 'B2'), -- crumpled (formal)
  (206242, 'مَسکونی', 'B1', 'B2'), -- residential (formal)
  (206243, 'یِکپارچه', 'B1', 'B2'), -- unified / integrated (formal)
  (206244, 'جَروبَحث', 'A2', 'B1'), -- argument / quarrel (informal)
  (206245, 'صَراحَت', 'B1', 'B2'), -- frankness / clarity (formal)
  (206246, 'اِعتِنا', 'B1', 'B2'), -- attention / regard (formal)
  (206247, 'سُنبُل', 'A2', 'B1'), -- hyacinth (flower)
  (206248, 'خودآگاه', 'B1', 'B2'), -- conscious / self-aware (formal)
  (206250, 'زیارَت', 'B1', 'B2'), -- pilgrimage (formal, religious)
  (206251, 'آگاهانه', 'B1', 'B2'), -- consciously (formal)
  (206252, 'طِفلَکی', 'B1', 'B2'), -- poor thing (informal, endearment)
  (206253, 'پارتیزان', 'B1', 'B2'), -- partisan / guerrilla fighter (loanword)
  (206254, 'مُذاب', 'B2', 'C1'), -- molten (formal, technical)
  (206255, 'نَعنا', 'A2', 'B1'), -- mint [herb]
  (206256, 'عَجول', 'B1', 'B2'), -- hasty / impatient (formal)
  (206257, 'ژامبون', 'A2', 'B1'), -- ham (loanword)
  (206258, 'مونتاژ', 'B1', 'B2'), -- montage / assembly (formal, film / tech)
  (206259, 'پُرتره', 'A2', 'B1'), -- portrait (loanword)
  (206260, 'ماندگار', 'B1', 'B2'), -- lasting / enduring (formal)
  (206262, 'مُرَتَّباً', 'B1', 'B2'), -- repeatedly (formal)
  (206263, 'نُجومی', 'B1', 'B2'), -- astronomical (formal)
  (206264, 'حُبوبات', 'B1', 'B2'), -- legumes (formal)
  (206265, 'ساقی', 'B2', 'C1'), -- cupbearer / wine-pourer (formal, literary)
  (206266, 'نَخل', 'A2', 'B1'), -- palm tree
  (206267, 'حَریق', 'B1', 'B2'), -- fire / blaze (formal, legal)
  (206268, 'تَفرِقه', 'B1', 'B2'), -- discord / division (formal)
  (206269, 'اِبلاغ', 'B1', 'B2'), -- notification (formal, legal; ابلاغ کردن = to notify)
  (206271, 'ماراتُن', 'A2', 'B1'), -- marathon (loanword)
  (206272, 'خیرخواه', 'B1', 'B2'), -- well-wisher / benevolent (formal)
  (206273, 'سوئیسی', 'A2', 'B1'), -- Swiss (nationality)
  (206274, 'سُخَنران', 'B1', 'B2'), -- speaker / lecturer (formal)
  (206276, 'رایِحه', 'B2', 'C1'), -- fragrance / scent (formal)
  (206277, 'پروتون', 'A2', 'B1'), -- proton (loanword)
  (206278, 'هِلال', 'B1', 'B2'), -- crescent (formal)
  (206279, 'مِحَک', 'B2', 'C1'), -- touchstone / test (formal)
  (206280, 'نَظافَتچی', 'A2', 'B1'), -- janitor / cleaner
  (206281, 'هَمنَوع', 'B2', 'C1'), -- fellow human (formal)
  (206283, 'هَوادار', 'B1', 'B2'), -- fan / supporter (formal)
  (206284, 'هلیوم', 'A2', 'B1'), -- helium (loanword)
  (206285, 'مَمنوعیَّت', 'B1', 'B2'), -- prohibition (formal)
  (206286, 'بِرِزیلی', 'A2', 'B1'), -- Brazilian (nationality)
  (206287, 'سونوگرافی', 'A2', 'B1'), -- ultrasound (loanword, medical)
  (206289, 'میانسال', 'B1', 'B2'), -- middle-aged (formal)
  (206290, 'باغبان', 'A2', 'B1'), -- gardener
  (206291, 'مُصاحِبَت', 'B2', 'C1'), -- companionship (formal)
  (206292, 'تیله', 'A2', 'B1'), -- marble [toy]
  (206293, 'شِنیداری', 'B1', 'B2'), -- auditory (formal)
  (206294, 'خُزَعبَلات', 'B2', 'C1'), -- nonsense / rubbish (formal, derogatory)
  (206295, 'طَنین', 'B1', 'B2'), -- resonance / echo (formal)
  (206296, 'مُتَراکِم', 'B1', 'B2'), -- dense / condensed (formal)
  (206297, 'وَحی', 'B2', 'C1'), -- divine revelation (formal, religious)
  (206298, 'سالیان', 'B2', 'C1'), -- years (formal, literary)
  (206299, 'رَصَد', 'B1', 'B2'), -- observation [astronomy] (formal)
  (206300, 'اُفُقی', 'B1', 'B2'), -- horizontal (formal)
  (206301, 'نُطق', 'B1', 'B2'), -- speech / oration (formal)
  (206302, 'ثانَویه', 'B1', 'B2'), -- secondary (formal)
  (206303, 'کِلافه', 'B1', 'B2'), -- frustrated / exasperated (formal)
  (206304, 'تَک‌شاخ', 'A2', 'B1'), -- unicorn
  (206305, 'مُرغابی', 'A2', 'B1'), -- duck [wild]
  (206306, 'سُبوس', 'A2', 'B1'), -- bran
  (206307, 'چاپلوس', 'B1', 'B2'), -- flatterer / sycophant (formal)
  (206308, 'هَمسان', 'B1', 'B2'), -- identical / similar (formal)
  (206309, 'اِستِحکامات', 'B1', 'B2'), -- fortifications (formal)
  (206310, 'یاوه', 'B1', 'B2'), -- nonsense (formal)
  (206311, 'هَمشَهری', 'B1', 'B2'), -- fellow townsman / citizen (formal)
  (206312, 'مِنقار', 'A2', 'B1'), -- beak
  (206313, 'غِبطه', 'B2', 'C1'), -- envy [benign] (formal)
  (206314, 'اِرتِعاش', 'B1', 'B2'), -- vibration (formal, physics)
  (206315, 'مُنحَنی', 'B1', 'B2'), -- curve (formal, math)
  (206317, 'تَرقُوه', 'B2', 'C1'), -- collarbone (formal, medical)
  (206318, 'فَجیع', 'B2', 'C1'), -- horrific / gruesome (formal)
  (206319, 'نایاب', 'B1', 'B2'), -- rare / unobtainable (formal)
  (206321, 'تَجلیل', 'B1', 'B2'), -- honoring / commemoration (formal)
  (206322, 'نُوین', 'B1', 'B2'), -- modern / new (formal, literary)
  (206323, 'مُبتَدی', 'B1', 'B2'), -- beginner (formal)
  (206324, 'دَریانَوَرد', 'B1', 'B2'), -- sailor / mariner
  (206325, 'هَمگام', 'B2', 'C1'), -- in step / synchronized (formal)
  (206326, 'شَبَکیه', 'B2', 'C1'), -- retina (medical)
  (206327, 'ناتَنی', 'B1', 'B2'), -- half- / step- [sibling] (formal)
  (206328, 'سَراشیبی', 'B1', 'B2'), -- downhill / slope (formal)
  (206329, 'اوزون', 'A2', 'B1'), -- ozone (loanword)
  (206330, 'لِقاح', 'B2', 'C1'), -- fertilization (formal, medical)
  (206332, 'اِنزِوا', 'B1', 'B2'), -- isolation / seclusion (formal)
  (206333, 'اِتِّخاذ', 'B1', 'B2'), -- adoption [of a policy] (formal)
  (206334, 'دِلچَسب', 'B1', 'B2'), -- pleasant / palatable (formal)
  (206335, 'ضَریب', 'B1', 'B2'), -- coefficient (formal, math)
  (206336, 'بُزُرگوار', 'B1', 'B2'), -- noble / magnanimous (formal)
  (206337, 'نِشأَت', 'B2', 'C1'), -- originating (formal; نشأت گرفتن = to originate from)
  (206338, 'پژواک', 'B1', 'B2'), -- echo (formal)
  (206339, 'سُکنه', 'B1', 'B2'), -- inhabitants / population (formal)
  (206340, 'مَطبوع', 'B1', 'B2'), -- pleasant (formal)
  (206341, 'لَجباز', 'A2', 'B1'), -- stubborn
  (206342, 'قِمارباز', 'B1', 'B2'), -- gambler
  (206343, 'اِسپُرت', 'A2', 'B1'), -- sporty / athletic (loanword)
  (206344, 'کُسوف', 'B1', 'B2'), -- solar eclipse (formal, astronomy)
  (206345, 'دیپلماسی', 'B1', 'B2'), -- diplomacy (formal)
  (206346, 'شَرافَتمَند', 'B1', 'B2'), -- honorable (formal)
  (206347, 'دِموکراتیک', 'B1', 'B2'), -- democratic (loanword)
  (206348, 'تَلفیق', 'B1', 'B2'), -- combination / synthesis (formal)
  (206350, 'اَلطاف', 'B2', 'C1'), -- kindnesses / favors (formal)
  (206351, 'بویایی', 'B1', 'B2'), -- sense of smell (formal)
  (206352, 'پَناهَندگی', 'B1', 'B2'), -- asylum / refugee status (formal)
  (206353, 'یِکراست', 'B1', 'B2'), -- straight / directly (formal)
  (206354, 'دیکته', 'A2', 'B1'), -- dictation (school)
  (206355, 'قَدَغَن', 'B1', 'B2'), -- forbidden / prohibited (formal)
  (206356, 'شاغِل', 'B1', 'B2'), -- employed (formal)
  (206357, 'مُتِمایِل', 'B1', 'B2'), -- inclined / leaning toward (formal)
  (206358, 'عایِق', 'B1', 'B2'), -- insulator / insulation (formal, technical)
  (206359, 'مُستَمَری', 'B1', 'B2'), -- pension / annuity (formal)
  (206360, 'مُسَطَّح', 'B1', 'B2'), -- flat / level (formal)
  (206361, 'دَمپایی', 'A2', 'B1'), -- slippers / flip-flops
  (206362, 'واگیردار', 'B1', 'B2'), -- contagious (formal, medical)
  (206364, 'حِجاب', 'A2', 'B1'), -- veil / hijab
  (206365, 'غَمناک', 'B1', 'B2'), -- sad / sorrowful (formal)
  (206366, 'فَرزَندخواندگی', 'B1', 'C1'), -- adoption (formal)
  (206367, 'یِکصَد', 'A2', 'B1'), -- one hundred (formal)
  (206368, 'تالاب', 'A2', 'B1'), -- wetland / marsh (formal)
  (206369, 'خورِشت', 'A1', 'A2'), -- stew
  (206370, 'هَمخوانی', 'B1', 'B2'), -- harmony / consonance (formal)
  (206373, 'ذَکاوَت', 'B2', 'C1'), -- intelligence / acumen (formal)
  (206374, 'بَندگی', 'B2', 'C1'), -- servitude / worship [religious] (formal)
  (206375, 'تَمجید', 'B1', 'B2'), -- praise / commendation (formal)
  (206376, 'مُتَغَیِّر', 'B1', 'B2'), -- variable (formal, math)
  (206377, 'پُرتُغالی', 'A2', 'B1'), -- Portuguese (nationality)
  (206378, 'آراسته', 'B1', 'B2'), -- adorned / well-groomed (formal)
  (206379, 'اِنجِماد', 'B2', 'C1'), -- freezing / solidification (formal, physics)
  (206380, 'خویشاوَند', 'B1', 'B2'), -- relative / kin (formal)
  (206381, 'پوشاک', 'A2', 'B1'), -- clothing / apparel (formal)
  (206382, 'نیکوتین', 'A2', 'B1'), -- nicotine (loanword)
  (206383, 'سِزارین', 'A2', 'B1'), -- cesarean section (loanword, medical)
  (206384, 'پماد', 'A2', 'B1'), -- ointment
  (206385, 'صَندَل', 'A2', 'B1'), -- sandal
  (206386, 'غَزَل', 'B1', 'B2'), -- lyric poem [ghazal] (formal, literary)
  (206387, 'حَکیم', 'B1', 'B2'), -- sage / wise physician (formal)
  (206388, 'تَحریف', 'B1', 'B2'), -- distortion [of facts] (formal)
  (206389, 'عِشوه', 'B2', 'C1'), -- coquetry / flirtation (formal, literary)
  (206390, 'لَرزان', 'B1', 'B2'), -- trembling / shaky (formal)
  (206391, 'زِندانبان', 'B1', 'B2'), -- jailer / prison guard
  (206393, 'مَرغوب', 'B1', 'B2'), -- high-quality (formal)
  (206394, 'رانِش', 'B1', 'B2'), -- landslide / drift (formal, geology)
  (206395, 'دَلالَت', 'B2', 'C1'), -- indication (formal; دلالت کردن = to indicate)
  (206396, 'قیر', 'A2', 'B1'), -- tar / asphalt binder
  (206397, 'یَخبَندان', 'B1', 'B2'), -- frost / freezing period (formal)
  (206398, 'مُشتَعِل', 'B2', 'C1'), -- ignited / ablaze (formal)
  (206399, 'رَشید', 'B1', 'B2'), -- handsome / valiant (formal)
  (206400, 'اِستِنباط', 'B2', 'C1'), -- inference / deduction (formal)
  (206401, 'وَرزیدَن', 'B1', 'B2'), -- to exercise / practice (formal)
  (206402, 'ناپاک', 'B1', 'B2'), -- impure / unclean
  (206403, 'مُنقَبِض', 'B2', 'C1'), -- contracted (formal)
  (206404, 'اَحشام', 'B2', 'C1'), -- livestock (formal)
  (206405, 'مُساعِد', 'B1', 'B2'), -- favorable / conducive (formal)
  (206406, 'تَقارُن', 'B1', 'B2'), -- symmetry (formal, math)
  (206407, 'عَلَفزار', 'A2', 'B1'), -- meadow / grassland (formal)
  (206408, 'ژِنوم', 'B1', 'B2'), -- genome (loanword)
  (206409, 'شیروانی', 'B1', 'B2'), -- rooftop / sloped roof
  (206410, 'تِگَرگ', 'A2', 'B1'), -- hail [weather]
  (206411, 'پَدافَند', 'B2', 'C1'), -- defense [military] (formal)
  (206412, 'مُعتَرِض', 'B1', 'B2'), -- protester (formal)
  (206413, 'خَصمانه', 'B1', 'B2'), -- hostile (formal)
  (206414, 'آبیاری', 'B1', 'B2'), -- irrigation (formal)
  (206415, 'ساتِن', 'A2', 'B1'), -- satin (loanword)
  (206416, 'لِذا', 'B2', 'C1'), -- therefore (formal, literary)
  (206417, 'سالخورده', 'B1', 'B2'), -- elderly (formal)
  (206418, 'واژگون', 'B1', 'B2'), -- overturned / inverted (formal)
  (206419, 'خَلوَتگاه', 'B2', 'C1'), -- secluded place / retreat (formal)
  (206420, 'اِستِثمار', 'B1', 'B2'), -- exploitation (formal)
  (206422, 'میلیمِتر', 'A2', 'B1'), -- millimeter (loanword)
  (206423, 'کارآموزی', 'B1', 'B2'), -- internship
  (206424, 'ناخالِص', 'B1', 'B2'), -- impure
  (206425, 'تَراکُم', 'B1', 'B2'), -- density / concentration (formal)
  (206426, 'مَخمَل', 'A2', 'B1'), -- velvet
  (206427, 'مَعرِفَت', 'B2', 'C1'), -- knowledge / gnosis (formal)
  (206428, 'نیشگون', 'A2', 'B1'), -- pinch (نیشگون گرفتن = to pinch)
  (206429, 'اَرز', 'B1', 'B2'), -- currency / foreign exchange (formal)
  (206430, 'غُنچه', 'A2', 'B1'), -- flower bud
  (206431, 'شادمانی', 'B1', 'B2'), -- joy / happiness (formal)
  (206432, 'کاربَر', 'A2', 'B1'), -- user (tech)
  (206433, 'قَطعنامه', 'B1', 'B2'), -- resolution [document] (formal)
  (206434, 'خودبِخود', 'B1', 'B2'), -- automatically / spontaneously (formal)
  (206435, 'آموزَنده', 'B1', 'B2'), -- instructive / educational (formal)
  (206436, 'تَلَنگُر', 'B1', 'B2'), -- flick / nudge (formal)
  (206437, 'فَیصَله', 'B1', 'B2'), -- settlement / resolution (formal)
  (206438, 'سَرشُماری', 'B1', 'B2'), -- census (formal)
  (206439, 'مَبدَأ', 'B1', 'B2'), -- origin / starting point (formal)
  (206440, 'سَرکارگَر', 'B1', 'B2'), -- foreman
  (206441, 'ناهَنجار', 'B1', 'B2'), -- abnormal / deviant (formal)
  (206442, 'هُنَرمَندانه', 'B1', 'B2'), -- artistically (formal)
  (206443, 'اِقتِدار', 'B1', 'B2'), -- authority / power (formal)
  (206444, 'دامپِزِشکی', 'A2', 'B1'), -- veterinary medicine [field]
  (206445, 'سَردَبیر', 'B1', 'B2'), -- editor-in-chief
  (206446, 'بارِز', 'B1', 'B2'), -- evident / obvious (formal)
  (206447, 'حَنجَره', 'B2', 'C1'), -- larynx (medical)
  (206448, 'غُرغُرو', 'A2', 'B1'), -- grumpy / grouchy person (informal)
  (206449, 'بُزاق', 'B2', 'C1'), -- saliva (formal, medical)
  (206450, 'تَحلیلگَر', 'B1', 'B2'), -- analyst (formal)
  (206451, 'بَمبگُذاری', 'B1', 'B2'), -- bombing
  (206452, 'کارما', 'A2', 'B1'), -- karma (loanword)
  (206453, 'تَنور', 'A2', 'B1'), -- oven / tandoor
  (206454, 'رَهسپار', 'B2', 'C1'), -- heading toward / departing (formal)
  (206455, 'سوءظَن', 'B1', 'B2'), -- suspicion (formal)
  (206456, 'نُجوم', 'B1', 'B2'), -- astronomy (formal)
  (206457, 'تَدریجی', 'B1', 'B2'), -- gradual (formal)
  (206458, 'فِداکار', 'B1', 'B2'), -- self-sacrificing (formal)
  (206459, 'گُلخانه', 'A2', 'B1'), -- greenhouse (formal)
  (206460, 'رؤیایی', 'B1', 'B2'), -- dreamy / fantastic (formal)
  (206461, 'اِستیناف', 'B2', 'C1'), -- appeal [legal] (formal)
  (206462, 'تَورات', 'B1', 'B2'), -- the Torah
  (206464, 'آئین', 'B1', 'B2'), -- custom / rite / ceremony (formal)
  (206465, 'ماوَراءالطَّبیعه', 'B2', 'C1'), -- supernatural / metaphysics (formal)
  (206466, 'عَصرانه', 'A2', 'B1'), -- afternoon snack
  (206467, 'عُریان', 'B1', 'B2'), -- naked / exposed (formal)
  (206468, 'رَستگار', 'B2', 'C1'), -- saved / redeemed (formal)
  (206469, 'رُعب', 'B1', 'B2'), -- terror / dread (formal)
  (206470, 'سَرشناس', 'B1', 'B2'), -- well-known / renowned (formal)
  (206471, 'بالینی', 'B2', 'C1'), -- clinical (formal, medical)
  (206472, 'سَرتیپ', 'B2', 'C1'), -- brigadier general (military rank)
  (206473, 'نَواده', 'B1', 'B2'), -- descendant / grandchild (formal)
  (206474, 'کیفَری', 'B1', 'B2'), -- criminal [legal] (formal)
  (206475, 'میسَّر', 'B1', 'B2'), -- possible / feasible (formal)
  (206476, 'دیزِل', 'A2', 'B1'), -- diesel (loanword)
  (206477, 'پیشخوان', 'A2', 'B1'), -- counter [shop] (formal)
  (206478, 'تأثیرگُذار', 'B1', 'B2'), -- influential (formal)
  (206479, 'پَند', 'B1', 'B2'), -- advice / counsel (formal, literary)
  (206480, 'جِلودار', 'B1', 'B2'), -- leader / frontrunner (formal)
  (206481, 'روبِل', 'A2', 'B1'), -- ruble [currency] (loanword)
  (206482, 'اُفتادگی', 'B2', 'C1'), -- humility / modesty (formal)
  (206483, 'نِمایِشگَر', 'A2', 'B1'), -- display / monitor (formal, tech)
  (206484, 'مُتِعارَف', 'B1', 'B2'), -- conventional / customary (formal)
  (206485, 'شُغال', 'A2', 'B1'), -- jackal
  (206486, 'خَفَقان', 'B1', 'B2'), -- suffocation / oppression (formal)
  (206487, 'دِلاوَری', 'B2', 'C1'), -- bravery (formal)
  (206489, 'بَرحَق', 'B1', 'B2'), -- rightful / justified (formal)
  (206490, 'دِلخوری', 'B1', 'B2'), -- resentment (formal)
  (206491, 'نَدامَت', 'B2', 'C1'), -- regret / repentance (formal)
  (206492, 'عَلوفه', 'B1', 'B2'), -- fodder / forage (agriculture)
  (206493, 'هَمنِشین', 'B2', 'C1'), -- companion / associate (formal)
  (206494, 'بازخواست', 'B1', 'B2'), -- interrogation / questioning (formal)
  (206495, 'بَدخیم', 'B2', 'C1'), -- malignant (formal, medical)
  (206496, 'غورباغه', 'A2', 'B1'), -- frog
  (206497, 'ساطور', 'A2', 'B1'), -- cleaver [knife]
  (206498, 'اِستِدعا', 'B2', 'C1'), -- request / plea (formal, archaic)
  (206499, 'مُستَلزِم', 'B2', 'C1'), -- requiring / necessitating (formal)
  (206500, 'رَواج', 'B1', 'B2'), -- prevalence (formal; رواج داشتن = to be prevalent)
  (206501, 'مُصَوَّر', 'B1', 'B2'), -- illustrated (formal)
  (206502, 'اِستِعمار', 'B1', 'B2'), -- colonialism (formal)
  (206503, 'مُقَوّی', 'B1', 'B2'), -- nutritious (formal)
  (206504, 'غارنِشین', 'B1', 'B2'), -- cave dweller (formal / historical)
  (206505, 'دَستپُخت', 'A2', 'B1'), -- home-cooking [someone's cooking]
  (206506, 'تَشابُه', 'B1', 'B2'), -- similarity / resemblance (formal)
  (206507, 'ذَلیل', 'B2', 'C1'), -- humiliated / wretched (formal)
  (206508, 'شَمشیرزَن', 'B1', 'B2'), -- swordsman
  (206509, 'خَمیده', 'B1', 'B2'), -- bent / stooped (formal)
  (206510, 'مَددکار', 'B1', 'B2'), -- social worker / helper (formal)
  (206511, 'ثَواب', 'B1', 'B2'), -- religious merit / good deed (formal)
  (206512, 'کَماکان', 'B2', 'C1'), -- still / as before (formal, literary)
  (206513, 'صالِح', 'B1', 'B2'), -- righteous / virtuous (formal)
  (206514, 'نانِوا', 'A2', 'B1'), -- baker
  (206515, 'اَلیاف', 'B1', 'B2'), -- fibers (formal)
  (206516, 'واگیر', 'B1', 'B2'), -- contagion (formal)
  (206517, 'ژَرف', 'B2', 'C1'), -- deep / profound (formal, literary)
  (206518, 'طالِب', 'B1', 'B2'), -- seeking / wanting (formal)
  (206519, 'سالنامه', 'B1', 'B2'), -- yearbook / almanac (formal)
  (206520, 'تَنگنا', 'B1', 'B2'), -- predicament / bottleneck (formal)
  (206521, 'مُتَّفِق', 'B1', 'B2'), -- allied / agreed (formal)
  (206522, 'مُتِّکی', 'B1', 'B2'), -- dependent / reliant (formal)
  (206523, 'نارِضایَتی', 'B1', 'B2'), -- dissatisfaction (formal)
  (206524, 'گورخَر', 'A1', 'A2'), -- zebra
  (206525, 'مِهمانخانه', 'A2', 'B1'), -- inn / guesthouse (formal)
  (206526, 'تُخمدان', 'B2', 'C1'), -- ovary (medical)
  (206527, 'لاکتوز', 'B1', 'B2'), -- lactose (loanword)
  (206528, 'مُتَضاد', 'B1', 'B2'), -- contradictory / opposite (formal)
  (206529, 'گُزینِش', 'B1', 'B2'), -- selection (formal)
  (206530, 'مدیترانه', 'B1', 'B2'), -- Mediterranean (formal, geography)
  (206531, 'وَریدی', 'B2', 'C1'), -- venous / intravenous (formal, medical)
  (206532, 'مَوضِعی', 'B1', 'B2'), -- local / topical (formal, medical)
  (206533, 'صَندوقدار', 'A2', 'B1'), -- cashier
  (206534, 'شاداب', 'B1', 'B2'), -- fresh / vibrant (formal)
  (206535, 'سِکسِکه', 'A2', 'B1'), -- hiccup
  (206536, 'دامداری', 'B1', 'B2'), -- animal husbandry (formal)
  (206537, 'بولتِن', 'B1', 'B2'), -- bulletin (loanword)
  (206538, 'عُرف', 'B1', 'B2'), -- custom / convention (formal, legal)
  (206539, 'عُموماً', 'B1', 'B2'), -- generally (formal)
  (206540, 'حَذَر', 'B1', 'B2'), -- caution (formal; حذر کردن = to beware)
  (206541, 'وارَسی', 'B1', 'B2'), -- inspection / scrutiny (formal)
  (206542, 'ناقِل', 'B1', 'B2'), -- carrier [disease] (formal, medical)
  (206543, 'عَنتَر', 'A2', 'B1'), -- monkey / ape (colloquial)
  (206544, 'جَنجالی', 'B1', 'B2'), -- controversial (formal)
  (206545, 'اَنگیزِش', 'B1', 'B2'), -- motivation (formal)
  (206546, 'سِپاسگُزاری', 'B1', 'B2'), -- gratitude / thanking (formal)
  (206547, 'قاچاقی', 'B1', 'B2'), -- smuggled / illicit (formal)
  (206548, 'اُستاندار', 'B1', 'B2'), -- governor [province] (formal)
  (206549, 'اَبهَت', 'B2', 'C1'), -- grandeur / majesty (formal)
  (206550, 'رِساله', 'B1', 'B2'), -- treatise / thesis (formal, academic)
  (206551, 'خُطبه', 'B1', 'B2'), -- sermon [religious / political] (formal)
  (206552, 'لَغزَنده', 'B1', 'B2'), -- slippery (formal)
  (206553, 'جَرح', 'B2', 'C1'), -- wound / injury [legal term] (formal)
  (206554, 'اَفغانی', 'A2', 'B1'), -- Afghan (nationality)
  (206555, 'تَبانی', 'B2', 'C1'), -- collusion (formal, legal)
  (206556, 'رِکاب', 'B1', 'B2'), -- stirrup / pedal (formal)
  (206557, 'کُدنویسی', 'B1', 'B2'), -- coding / programming (formal, tech)
  (206558, 'آلومینیوم', 'A2', 'B1'), -- aluminum (loanword)
  (206559, 'قَلَمداد', 'B1', 'B2'), -- regarded as (formal; قلمداد کردن = to regard as)
  (206560, 'دَردآوَر', 'B1', 'B2'), -- painful
  (206561, 'وِلایَت', 'B2', 'C1'), -- province / guardianship (formal)
  (206562, 'مَردانگی', 'B1', 'B2'), -- manliness / virility (formal)
  (206563, 'وُصول', 'B1', 'B2'), -- collection / receipt [of payment] (formal)
  (206564, 'مَصالِح', 'B1', 'B2'), -- materials [construction] (formal)
  (206565, 'شَفّافیَّت', 'B1', 'B2'), -- transparency (formal)
  (206566, 'بَسط', 'B1', 'B2'), -- expansion / elaboration (formal)
  (206568, 'نازا', 'B2', 'C1'), -- infertile / barren (formal, medical)
  (206569, 'رُنسانس', 'B1', 'B2'), -- Renaissance (loanword, historical)
  (206571, 'موزون', 'B1', 'B2'), -- rhythmic / well-proportioned (formal)
  (206572, 'اِسکاندیناوی', 'B1', 'B2'), -- Scandinavian (formal)
  (206574, 'تَرخیص', 'B1', 'B2'), -- discharge / release [customs, hospital] (formal)
  (206575, 'زِبر', 'B1', 'B2'), -- rough / coarse [surface] (formal)
  (206576, 'تَرویج', 'B1', 'B2'), -- promotion / propagation (formal)
  (206577, 'سوسَن', 'A2', 'B1'), -- lily (flower)
  (206578, 'جَوانمَردانه', 'B1', 'B2'), -- chivalrously (formal)
  (206579, 'نُطفه', 'B2', 'C1'), -- embryo / seed (formal, biology)
  (206580, 'سَرافکَنده', 'B1', 'B2'), -- ashamed / downcast (formal)
  (206581, 'سَماجَت', 'B2', 'C1'), -- persistence / stubbornness (formal)
  (206582, 'کِردار', 'B1', 'B2'), -- deed / action (formal, literary)
  (206583, 'لَطافَت', 'B1', 'B2'), -- softness / delicacy (formal)
  (206585, 'فوتبالیست', 'A2', 'B1'), -- footballer (loanword)
  (206586, 'تَجَلّی', 'B1', 'B2'), -- manifestation (formal)
  (206587, 'مَسَرَّت', 'B2', 'C1'), -- happiness / delight (formal)
  (206588, 'عَقیم', 'B2', 'C1'), -- sterile / infertile (formal)
  (206589, 'تَجهیز', 'B1', 'B2'), -- equipping (formal)
  (206590, 'هَرَس', 'A2', 'B1'), -- pruning (formal; هرس کردن = to prune)
  (206591, 'موتورسوار', 'A2', 'B1'), -- motorcyclist
  (206592, 'آناتومی', 'B1', 'B2'), -- anatomy (loanword)
  (206593, 'غایِب', 'B1', 'B2'), -- absent (formal)
  (206594, 'قیاس', 'B1', 'B2'), -- analogy / comparison (formal, logic)
  (206595, 'لَفظی', 'B1', 'B2'), -- verbal / literal (formal)
  (206596, 'تَوفیق', 'B2', 'C1'), -- success [divine blessing sense] (formal)
  (206597, 'شَبیخون', 'B1', 'B2'), -- night raid / ambush (formal, military)
  (206598, 'مَدنَظَر', 'B1', 'B2'), -- in view / under consideration (formal)
  (206599, 'زَنجَبیل', 'A2', 'B1'), -- ginger
  (206600, 'مُختَلِط', 'B1', 'B2'), -- mixed / coeducational (formal)
  (206601, 'مَنشور', 'B1', 'B2'), -- charter; prism (formal)
  (206602, 'ماجراجو', 'B1', 'B2'), -- adventurer
  (206603, 'تَرحیم', 'B2', 'C1'), -- funeral / condolence ceremony (formal, religious)
  (206604, 'حَرَم', 'B1', 'B2'), -- shrine / harem (formal, religious / historical)
  (206605, 'آهَک', 'A2', 'B1'), -- lime [mineral, construction] (formal)
  (206606, 'وِراثَت', 'B1', 'B2'), -- heredity / inheritance (formal)
  (206607, 'روتین', 'A2', 'B1'), -- routine (loanword)
  (206608, 'سَرمَشق', 'B1', 'B2'), -- role model / example (formal)
  (206609, 'ساقِط', 'B1', 'B2'), -- overthrown / fallen (formal)
  (206610, 'فَخر', 'B1', 'B2'), -- pride / honor (formal)
  (206611, 'تَوَقُّفگاه', 'A2', 'B1'), -- parking lot / stopping place
  (206612, 'تَعبیه', 'B1', 'B2'), -- installation / embedding (formal)
  (206613, 'غیرمَنطِقی', 'B1', 'B2'), -- illogical
  (206614, 'اَفشاگَر', 'B1', 'B2'), -- whistleblower / exposer (formal)
  (206615, 'مَظهَر', 'B2', 'C1'), -- manifestation / symbol (formal)
  (206616, 'کُلِسترول', 'A2', 'B1'), -- cholesterol (loanword)
  (206617, 'فَعّال‌سازی', 'B1', 'B2'), -- activation (formal, tech)
  (206618, 'گَوارِش', 'B1', 'B2'), -- digestion (formal, medical)
  (206619, 'کاستی', 'B1', 'B2'), -- shortcoming / deficiency (formal)
  (206620, 'گُسَل', 'B1', 'B2'), -- fault [geology] (formal)
  (206621, 'خویشاوَندی', 'B1', 'B2'), -- kinship (formal)
  (206622, 'مَشی', 'B1', 'B2'), -- policy / course of action (formal)
  (206623, 'روانکاوی', 'B1', 'B2'), -- psychoanalysis (formal)
  (206624, 'کارنامه', 'A2', 'B1'), -- report card / record (formal)
  (206625, 'خَمیازه', 'A2', 'B1'), -- yawn (خمیازه کشیدن = to yawn)
  (206626, 'مَخروبه', 'B1', 'B2'), -- ruins / dilapidated place (formal)
  (206627, 'اِسفِناج', 'A1', 'A2'), -- spinach
  (206628, 'مکانیزم', 'A2', 'B1'), -- mechanism (loanword)
  (206629, 'مُبتَذَل', 'B2', 'C1'), -- vulgar / tacky [content] (formal)
  (206630, 'مُتِظاهِر', 'B1', 'B2'), -- hypocritical / pretending (formal)
  (206631, 'مَکّار', 'B1', 'B2'), -- cunning / deceitful (formal)
  (206632, 'اَموات', 'B2', 'C1'), -- the deceased (formal)
  (206633, 'شِکافت', 'B2', 'C1'), -- split / fission (formal, physics)
  (206634, 'شوکَران', 'B2', 'C1'), -- hemlock (poison plant)
  (206635, 'توانبَخشی', 'B1', 'B2'), -- rehabilitation (formal, medical)
  (206636, 'پُشتَک', 'A2', 'B1'), -- somersault (پشتک زدن = to do a somersault)
  (206637, 'فَراگیر', 'B1', 'B2'), -- comprehensive / widespread (formal)
  (206639, 'تَفَرُّجگاه', 'B1', 'B2'), -- recreation area / resort (formal)
  (206640, 'نِسبی', 'B1', 'B2'), -- relative (formal)
  (206641, 'تَرَشُّحات', 'B2', 'C1'), -- secretions (formal, medical)
  (206642, 'تَنَقُّلات', 'A2', 'B1'), -- snacks (formal)
  (206643, 'تَعَصُّب', 'B1', 'B2'), -- prejudice / bigotry (formal)
  (206644, 'فَرسایِش', 'B1', 'B2'), -- erosion (formal, geology)
  (206645, 'لَفظ', 'B1', 'B2'), -- word / term (formal)
  (206646, 'خَربُزه', 'A1', 'A2'), -- melon [cantaloupe]
  (206647, 'مَرام', 'B1', 'B2'), -- creed / code of conduct (formal)
  (206648, 'نَهان', 'B2', 'C1'), -- hidden (formal, literary)
  (206649, 'خُروشان', 'B2', 'C1'), -- roaring / turbulent (formal, literary)
  (206650, 'اَفسونگَر', 'B1', 'B2'), -- enchanter / charmer (formal)
  (206651, 'مَبحَث', 'B1', 'B2'), -- topic / subject [academic] (formal)
  (206652, 'اَبَرقُدرَت', 'B1', 'B2'), -- superpower
  (206654, 'مَدخَل', 'B1', 'B2'), -- entrance / entry [dictionary] (formal)
  (206655, 'روشَنفِکر', 'B1', 'B2'), -- intellectual (formal)
  (206656, 'مُدَرِّس', 'B1', 'B2'), -- instructor / teacher (formal)
  (206657, 'مُقَیَّد', 'B1', 'B2'), -- bound / committed to (formal)
  (206658, 'اِخلال', 'B1', 'B2'), -- disruption (formal; اخلال کردن = to disrupt)
  (206659, 'ماهیتابه', 'A2', 'B1'), -- frying pan
  (206660, 'نَمادین', 'B1', 'B2'), -- symbolic (formal)
  (206661, 'بَسیج', 'B1', 'B2'), -- mobilization (formal)
  (206662, 'رونَمایی', 'B1', 'B2'), -- unveiling (formal)
  (206663, 'گُسیخته', 'B2', 'C1'), -- torn / severed (formal)
  (206664, 'قُلوه', 'B1', 'B2'), -- kidney [food / anatomical] (formal)
  (206665, 'تَجدیدنَظَر', 'B1', 'B2'), -- reconsideration / appeal (formal, legal)
  (206666, 'آدَمخوار', 'B1', 'B2'), -- cannibal (formal)
  (206667, 'اَنبَردَست', 'A2', 'B1'), -- pliers
  (206668, 'دیالیز', 'B1', 'B2'), -- dialysis (loanword, medical)
  (206669, 'بانکداری', 'B1', 'B2'), -- banking (formal)
  (206670, 'فیلمسازی', 'B1', 'B2'), -- filmmaking (formal)
  (206671, 'تِرومپِت', 'A2', 'B1'), -- trumpet (loanword)
  (206672, 'مِساحَت', 'B1', 'B2'), -- area [measurement] (formal, geometry)
  (206673, 'پیستون', 'A2', 'B1'), -- piston (loanword)
  (206674, 'بَستِگان', 'B1', 'B2'), -- relatives (formal)
  (206675, 'فَلسَفی', 'B1', 'B2'), -- philosophical (formal)
  (206676, 'هَوانَوَردی', 'B1', 'B2'), -- aviation (formal)
  (206677, 'سَرگُذَشت', 'B1', 'B2'), -- life story / biography (formal)
  (206678, 'اِکسیر', 'B2', 'C1'), -- elixir (formal, literary)
  (206679, 'کالباس', 'A2', 'B1'), -- bologna / sausage [cold cuts] (loanword)
  (206680, 'بَخشایِش', 'B2', 'C1'), -- forgiveness (formal)
  (206681, 'داربَست', 'A2', 'B1'), -- scaffolding
  (206682, 'نَفَقه', 'B2', 'C1'), -- alimony (formal, legal)
  (206683, 'توخالی', 'B1', 'B2'), -- hollow (formal)
  (206684, 'مَحرومیَّت', 'B1', 'B2'), -- deprivation / ban (formal)
  (206685, 'تَجرُبی', 'B1', 'B2'), -- empirical / experimental (formal)
  (206686, 'سیاحَت', 'B1', 'B2'), -- tourism / travel (formal, literary)
  (206687, 'غیرمَعمول', 'B1', 'B2'), -- unusual / uncommon (formal)
  (206688, 'مادیان', 'A2', 'B1'), -- mare [female horse]
  (206689, 'مَلال', 'B2', 'C1'), -- boredom / melancholy (formal, literary)
  (206690, 'نابالِغ', 'B1', 'B2'), -- immature / underage (formal)
  (206691, 'باوَقار', 'B1', 'B2'), -- dignified (formal)
  (206692, 'آبرومَند', 'B1', 'B2'), -- respectable / honorable (formal)
  (206693, 'ناوبان', 'B2', 'C1'), -- petty officer [naval rank]
  (206694, 'سَمبوسه', 'A2', 'B1'), -- samosa (loanword)
  (206695, 'وَخامَت', 'B2', 'C1'), -- severity / gravity [of situation] (formal)
  (206696, 'مَذکور', 'B1', 'B2'), -- aforementioned (formal)
  (206697, 'بالماسکه', 'B1', 'B2'), -- masquerade ball (formal)
  (206698, 'رَباط', 'B2', 'C1'), -- ligament (medical)
  (206699, 'مُخَلَّفات', 'B1', 'B2'), -- accompaniments / side dishes (formal)
  (206700, 'نَشر', 'B1', 'B2'), -- publishing (formal)
  (206701, 'سینوس', 'B1', 'B2'), -- sinus (loanword, medical)
  (206702, 'بَدگُمانی', 'B1', 'B2'), -- suspicion / distrust (formal)
  (206703, 'نیکوکار', 'B1', 'B2'), -- benefactor / philanthropist (formal)
  (206704, 'آتِش‌نِشان', 'A2', 'B1'), -- firefighter
  (206705, 'ظُلمَت', 'B2', 'C1'), -- darkness (formal, literary)
  (206706, 'پورتال', 'B1', 'B2'), -- portal (loanword, tech)
  (206707, 'راستین', 'B2', 'C1'), -- genuine / true (formal, literary)
  (206708, 'بالگَرد', 'A2', 'B1'), -- helicopter (formal)
  (206709, 'غاصِب', 'B2', 'C1'), -- usurper (formal)
  (206710, 'والیبال', 'A1', 'A2'), -- volleyball (loanword)
  (206711, 'زَنبَق', 'A2', 'B1'), -- iris / lily [flower]
  (206712, 'آمونیاک', 'A2', 'B1'), -- ammonia (loanword)
  (206713, 'پیشاپیش', 'B1', 'B2'), -- beforehand / in advance (formal)
  (206714, 'بَرافراشته', 'B2', 'C1'), -- raised / hoisted [flag] (formal)
  (206715, 'سَرزِندگی', 'B1', 'B2'), -- vitality / liveliness (formal)
  (206716, 'شَرعی', 'B1', 'B2'), -- religious / canonical [Islamic law] (formal)
  (206717, 'مارماهی', 'A2', 'B1'), -- eel
  (206718, 'پِلاکِت', 'B1', 'B2'), -- platelet (loanword, medical)
  (206719, 'مُرَفَّه', 'B1', 'B2'), -- affluent / prosperous (formal)
  (206720, 'خودسَرانه', 'B1', 'B2'), -- arbitrarily (formal)
  (206721, 'کارفَرما', 'A2', 'B1'), -- employer
  (206722, 'خُرطوم', 'A2', 'B1'), -- trunk [elephant] / proboscis (formal)
  (206723, 'سِندیکا', 'B1', 'B2'), -- union / syndicate (loanword)
  (206724, 'موسیقیدان', 'B1', 'B2'), -- musician (formal)
  (206725, 'رُسوب', 'B1', 'B2'), -- sediment / deposit (formal)
  (206726, 'مُقیم', 'B1', 'B2'), -- resident (formal)
  (206727, 'خاطِرخواه', 'B2', 'C1'), -- suitor / admirer (formal)
  (206728, 'کُدگُذاری', 'B1', 'B2'), -- encoding (formal, tech)
  (206729, 'دِهات', 'B1', 'B2'), -- villages (formal)
  (206730, 'خُداوَندگار', 'B2', 'C1'), -- lord / master (formal, archaic)
  (206731, 'بَدافزار', 'B1', 'B2'), -- malware (formal, tech)
  (206732, 'مُنتَفی', 'B1', 'B2'), -- void / no longer applicable (formal)
  (206733, 'راهکار', 'B1', 'B2'), -- solution / strategy (formal)
  (206734, 'پُرشور', 'B1', 'B2'), -- passionate / enthusiastic (formal)
  (206735, 'نیابَت', 'B2', 'C1'), -- deputyship / proxy (formal)
  (206736, 'وَلخَرج', 'B1', 'B2'), -- spendthrift (formal)
  (206737, 'پاپیون', 'A2', 'B1'), -- bow tie (loanword)
  (206738, 'لِحاف', 'A2', 'B1'), -- quilt / comforter
  (206739, 'دِلبَستگی', 'B1', 'B2'), -- attachment / fondness (formal)
  (206740, 'آغُل', 'A2', 'B1'), -- sheep pen / animal enclosure
  (206741, 'گُروگانگیری', 'B1', 'B2'), -- hostage-taking (formal)
  (206742, 'نورافکَن', 'B1', 'B2'), -- spotlight / floodlight (formal)
  (206743, 'دِلفَریب', 'B2', 'C1'), -- captivating / charming (formal, literary)
  (206744, 'مَمیّز', 'B1', 'B2'), -- auditor / censor (formal)
  (206745, 'دَلّالی', 'B1', 'B2'), -- brokering / mediation (formal)
  (206746, 'اِنقِضا', 'B1', 'B2'), -- expiration (formal)
  (206747, 'اَماکِن', 'B1', 'B2'), -- places / locations (formal)
  (206748, 'گیوتین', 'B1', 'B2'), -- guillotine (loanword)
  (206749, 'شَریر', 'B1', 'B2'), -- wicked / villainous (formal)
  (206750, 'مُلتَفِت', 'B2', 'C1'), -- aware / attentive (formal, archaic)
  (206751, 'نَفخ', 'B1', 'B2'), -- bloating (medical)
  (206752, 'رُسوخ', 'B2', 'C1'), -- infiltration / penetration (formal)
  (206753, 'فارِنهایت', 'A2', 'B1'), -- Fahrenheit (loanword)
  (206754, 'هَیبَت', 'B2', 'C1'), -- imposing presence / awe (formal)
  (206756, 'خودشیفته', 'B1', 'B2'), -- narcissistic (formal)
  (206757, 'تَداعی', 'B2', 'C1'), -- association [of ideas] (formal)
  (206758, 'گلوتِن', 'B1', 'B2'), -- gluten (loanword)
  (206759, 'مَغناطیس', 'B1', 'B2'), -- magnetism (formal)
  (206760, 'گَرمکَن', 'A2', 'B1'), -- tracksuit / sweatsuit (informal)
  (206761, 'مادَرخوانده', 'A2', 'B1'), -- adoptive mother
  (206762, 'اِستروژن', 'B2', 'C1'), -- estrogen (loanword, medical)
  (206763, 'بَرهوت', 'B2', 'C1'), -- wasteland / desert (formal, literary)
  (206764, 'حَصیری', 'A2', 'B1'), -- wicker / straw-woven
  (206765, 'خوکچه', 'A2', 'B1'), -- piglet / guinea pig
  (206766, 'اِعلان', 'B1', 'B2'), -- announcement (formal)
  (206767, 'شَکیبایی', 'B2', 'C1'), -- patience (formal, literary)
  (206768, 'اِجمالی', 'B1', 'B2'), -- brief / summary (formal)
  (206769, 'قِرائَت', 'B1', 'B2'), -- recitation / reading (formal)
  (206770, 'بَمبگُذار', 'B1', 'B2'), -- bomber [person who plants bombs]
  (206771, 'خُردکُن', 'A2', 'B1'), -- grinder / chopper [kitchen tool]
  (206772, 'خونخواهی', 'B2', 'C1'), -- vengeance / blood feud (formal)
  (206773, 'قُصور', 'B1', 'B2'), -- negligence / shortcoming (formal, legal)
  (206774, 'خُطابه', 'B1', 'B2'), -- oration / speech (formal)
  (206775, 'اِسکان', 'B1', 'B2'), -- accommodation / settlement (formal)
  (206776, 'هَمبَستگی', 'B1', 'B2'), -- solidarity (formal)
  (206777, 'عَرش', 'B2', 'C1'), -- throne [heavenly] (formal, religious)
  (206778, 'دُنیَوی', 'B1', 'B2'), -- worldly / secular (formal)
  (206779, 'تَعَلُّل', 'B1', 'B2'), -- procrastination (formal)
  (206780, 'بازدَم', 'B1', 'B2'), -- exhalation (formal, medical)
  (206781, 'اَزخودگُذَشتگی', 'B2', 'C2'), -- self-sacrifice (formal)
  (206782, 'خِصلَت', 'B1', 'B2'), -- trait / characteristic (formal)
  (206784, 'فُرمَت', 'A2', 'B1'), -- format (loanword)
  (206785, 'پَرچین', 'A2', 'B1'), -- hedge / fence (formal)
  (206786, 'قَیِّم', 'B1', 'B2'), -- guardian [legal] (formal)
  (206787, 'صِنف', 'B1', 'B2'), -- guild / trade [professional category] (formal)
  (206788, 'مَنجَلاب', 'B1', 'B2'), -- swamp / quagmire (formal, figurative)
  (206789, 'ناخوانده', 'B1', 'B2'), -- uninvited (formal)
  (206790, 'راکِد', 'B1', 'B2'), -- stagnant (formal)
  (206791, 'خیالبافی', 'B1', 'B2'), -- daydreaming (formal)
  (206792, 'سوپاپ', 'A2', 'B1'), -- valve [mechanical] (loanword)
  (206793, 'سوختگیری', 'B1', 'B2'), -- refueling (formal)
  (206794, 'حَوالی', 'B1', 'B2'), -- vicinity / surroundings (formal)
  (206795, 'ریاکار', 'B1', 'B2'), -- hypocrite (formal)
  (206796, 'گیاهخوار', 'A2', 'B1'), -- herbivore / vegetarian
  (206797, 'هَنگَفت', 'B1', 'B2'), -- huge / enormous [amount] (formal)
  (206798, 'مُتَبَرَّک', 'B2', 'C1'), -- blessed / sacred (formal)
  (206799, 'تَبخیر', 'B1', 'B2'), -- evaporation (formal, chemistry)
  (206800, 'سُکون', 'B1', 'B2'), -- stillness / stasis (formal)
  (206801, 'سَربَسته', 'B1', 'B2'), -- veiled / indirect [speech] (formal)
  (206802, 'تِرموستات', 'A2', 'B1'), -- thermostat (loanword)
  (206803, 'فُسفُر', 'A2', 'B1'), -- phosphorus (loanword)
  (206804, 'جَولان', 'B2', 'C1'), -- roaming / rampaging (formal)
  (206805, 'فَزاینده', 'B1', 'B2'), -- increasing (formal)
  (206806, 'عَیش', 'B2', 'C1'), -- pleasure / enjoyment (formal, literary)
  (206807, 'عُمران', 'B1', 'B2'), -- construction / development [civil engineering] (formal)
  (206808, 'سُستی', 'B1', 'B2'), -- laziness / weakness (formal)
  (206809, 'عُروج', 'B2', 'C1'), -- ascension (formal, religious / literary)
  (206810, 'قایِقرانی', 'A2', 'B1'), -- boating / rowing (formal)
  (206812, 'هَمدِلی', 'B1', 'B2'), -- empathy / compassion (formal)
  (206813, 'رَنجیده', 'B1', 'B2'), -- hurt / offended (formal)
  (206814, 'بَغرَنج', 'B1', 'B2'), -- complicated / complex (formal)
  (206816, 'اَرمَنی', 'A2', 'B1'), -- Armenian (nationality)
  (206818, 'سَرنیزه', 'B2', 'C1'), -- bayonet (military)
  (206819, 'دارودَسته', 'B1', 'B2'), -- gang / clique (formal)
  (206820, 'نویز', 'B1', 'B2'), -- noise (loanword, technical)
  (206821, 'شَهد', 'B1', 'B2'), -- nectar (formal)
  (206822, 'پِژوهِشگَر', 'B1', 'B2'), -- researcher (formal)
  (206823, 'ناموس', 'B1', 'B2'), -- honor / chastity [family honor concept] (cultural)
  (206824, 'دُگمه', 'A2', 'B1'), -- button [clothing]
  (206825, 'فَناپَذیر', 'B2', 'C1'), -- perishable / mortal (formal)
  (206826, 'اَفزوده', 'B1', 'B2'), -- added / augmented (formal)
  (206828, 'کُنج', 'B1', 'B2'), -- corner / nook (formal)
  (206829, 'پَرتابه', 'B1', 'B2'), -- projectile (formal)
  (206830, 'کاربَلَد', 'A2', 'B1'), -- competent / skilled (informal)
  (206831, 'دَرماندگی', 'B1', 'B2'), -- helplessness (formal)
  (206832, 'تَقَبُّل', 'B2', 'C1'), -- undertaking [responsibility] (formal)
  (206833, 'یابَنده', 'B1', 'B2'), -- finder (formal)
  (206834, 'گُشاده', 'B2', 'C1'), -- open / spacious (formal)
  (206835, 'گوژپُشت', 'B1', 'B2'), -- hunchback
  (206836, 'مُتَناقِض', 'B1', 'B2'), -- contradictory / paradoxical (formal)
  (206837, 'اَقلام', 'B1', 'B2'), -- items [commercial] (formal)
  (206838, 'مَعبَر', 'B1', 'B2'), -- passage / crossing (formal)
  (206839, 'مَشمول', 'B1', 'B2'), -- subject to / covered by [regulation] (formal)
  (206840, 'تَمَلُّک', 'B1', 'B2'), -- ownership / possession (formal)
  (206841, 'شاخَک', 'A2', 'B1'), -- antenna [insect] (formal)
  (206842, 'پابَرَهنه', 'A2', 'B1'), -- barefoot
  (206843, 'بازخورد', 'B1', 'B2'), -- feedback (formal)
  (206844, 'بِالفِطره', 'B2', 'C1'), -- innately / by nature (formal)
  (206845, 'نالیدَن', 'B1', 'B2'), -- to moan / complain [literary]
  (206846, 'سَروسامون', 'B1', 'B2'), -- order / settled state (formal)
  (206847, 'هواشناس', 'A2', 'B1'), -- meteorologist
  (206848, 'پایکوبی', 'B1', 'B2'), -- dancing / celebrating (formal)
  (206849, 'عافیَت', 'B2', 'C1'), -- well-being / health (formal, literary)
  (206850, 'پروستات', 'B1', 'B2'), -- prostate (loanword, medical)
  (206851, 'سَرخوشی', 'B1', 'B2'), -- euphoria / elation (formal)
  (206852, 'بارَندگی', 'A2', 'B1'), -- precipitation / rainfall (formal)
  (206853, 'سَرسَبز', 'A2', 'B1'), -- lush / verdant (formal)
  (206854, 'مُبَرّا', 'B2', 'C1'), -- exempt / free from (formal)
  (206855, 'تَدبیر', 'B1', 'B2'), -- strategy / measure (formal)
  (206856, 'بَقّالی', 'A2', 'B1'), -- grocery store
  (206857, 'دِرازا', 'B2', 'C1'), -- length [extent] (formal)
  (206858, 'وَحشَتزَده', 'B1', 'B2'), -- terrified (formal)
  (206859, 'تَلاقی', 'B1', 'B2'), -- convergence / intersection (formal)
  (206860, 'بُرهان', 'B1', 'B2'), -- proof / argument (formal, logic)
  (206861, 'مَهتابی', 'A2', 'B1'), -- moonlit; fluorescent light tube
  (206862, 'دَستکَم', 'B1', 'B2'), -- at least (formal)
  (206863, 'ناسازگاری', 'B1', 'B2'), -- incompatibility (formal)
  (206864, 'تاندون', 'A2', 'B1'), -- tendon (loanword, medical)
  (206865, 'مَلَکوت', 'B2', 'C1'), -- heavenly kingdom (formal, religious / literary)
  (206866, 'جوشکاری', 'A2', 'B1'), -- welding (formal)
  (206867, 'تَداوُم', 'B1', 'B2'), -- continuity (formal)
  (206868, 'آموزگار', 'A2', 'B1'), -- teacher / educator (formal)
  (206869, 'نامَحسوس', 'B1', 'B2'), -- imperceptible (formal)
  (206870, 'باجِناق', 'B2', 'C1'), -- brother-in-law [wife's sister's husband]
  (206871, 'مَرئی', 'B1', 'B2'), -- visible (formal)
  (206872, 'چابُک', 'B1', 'B2'), -- agile / nimble (formal)
  (206873, 'وَصیَّت‌نامه', 'B1', 'B2'), -- will / testament document (formal)
  (206874, 'شوینده', 'A2', 'B1'), -- detergent / cleanser (formal)
  (206875, 'قَطعیَّت', 'B1', 'B2'), -- certainty (formal)
  (206876, 'پاکدامَن', 'B2', 'C1'), -- chaste / virtuous (formal)
  (206877, 'پانسیون', 'A2', 'B1'), -- boarding house (loanword)
  (206878, 'دِگَر', 'B2', 'C1'), -- other / another (formal, literary)
  (206879, 'تَقَدُّم', 'B1', 'B2'), -- precedence / priority (formal)
  (206880, 'اَندوخته', 'B1', 'B2'), -- savings / accumulated wealth (formal)
  (206881, 'کاغَذبازی', 'B1', 'B2'), -- bureaucracy / red tape (informal)
  (206882, 'جَهل', 'B1', 'B2'), -- ignorance (formal)
  (206883, 'تَراشیدَن', 'B1', 'B2'), -- to shave / to carve
  (206884, 'ویرانه', 'B1', 'B2'), -- ruins (formal)
  (206885, 'چَراگاه', 'A2', 'B1'), -- pasture (formal)
  (206886, 'ناشناسی', 'B1', 'B2'), -- anonymity (formal)
  (206887, 'مُحَقَّر', 'B2', 'C1'), -- humble / modest [dwelling] (formal)
  (206888, 'دُخترخاله', 'A2', 'B1'), -- maternal aunt's daughter [cousin]
  (206889, 'سِپید', 'B2', 'C1'), -- white (formal, literary)
  (206890, 'قُربانگاه', 'B2', 'C1'), -- altar / sacrificial site (formal, religious)
  (206891, 'اِنطِباق', 'B1', 'B2'), -- conformity / adaptation (formal)
  (206892, 'بامیه', 'A2', 'B1'), -- okra
  (206893, 'اِجلاس', 'B1', 'B2'), -- summit / conference (formal, political)
  (206894, 'اَهدایی', 'B1', 'B2'), -- donated (formal)
  (206895, 'دِلگیر', 'B1', 'B2'), -- gloomy / dreary (formal)
  (206896, 'کِتمان', 'B1', 'B2'), -- concealment (formal; کتمان کردن = to conceal)
  (206897, 'بیکَران', 'B2', 'C1'), -- boundless / infinite (formal, literary)
  (206898, 'شُترمُرغ', 'A1', 'A2'), -- ostrich
  (206899, 'خارپُشت', 'A2', 'B1'), -- hedgehog
  (206900, 'پیکَره', 'B1', 'B2'), -- figure / statue; body (formal)
  (206901, 'قَرنیه', 'B2', 'C1'), -- cornea (medical)
  (206902, 'رَکیک', 'B1', 'B2'), -- obscene / vulgar [language] (formal)
  (206903, 'عِشاء', 'B2', 'C1'), -- dinner / supper [formal, esp. religious]
  (206904, 'سِفارَتخانه', 'A2', 'B1'), -- embassy building
  (206905, 'اِقامه', 'B2', 'C1'), -- performance [of prayer / lawsuit] (formal)
  (206906, 'نیایِش', 'B1', 'B2'), -- prayer / worship (formal, literary)
  (206907, 'تَناسُخ', 'B2', 'C1'), -- reincarnation (formal, philosophical / religious)
  (206909, 'ایجاب', 'B1', 'B2'), -- requirement / necessitation (formal; ایجاب کردن = to necessitate)
  (206910, 'تَقَدُّس', 'B2', 'C1'), -- sanctity (formal)
  (206911, 'تَقوا', 'B1', 'B2'), -- piety / righteousness (formal, religious)
  (206912, 'نوآوری', 'B1', 'B2'), -- innovation (formal)
  (206913, 'شَفَق', 'B2', 'C1'), -- twilight / dusk glow (formal, literary)
  (206914, 'بیولوژی', 'A2', 'B1'), -- biology (loanword)
  (206915, 'دَعاوی', 'B2', 'C1'), -- lawsuits / claims [legal] (formal)
  (206916, 'دِلواپَسی', 'B1', 'B2'), -- anxiety / worry (formal)
  (206917, 'مُنعَطِف', 'B1', 'B2'), -- flexible (formal)
  (206918, 'قیمه', 'A2', 'B1'), -- Persian meat-and-legume stew
  (206919, 'وَفادارانه', 'B1', 'B2'), -- loyally (formal)
  (206920, 'سَنگسار', 'B2', 'C1'), -- stoning [punishment] (formal)
  (206921, 'تریلیون', 'A2', 'B1'), -- trillion (loanword)
  (206922, 'خوشنود', 'B1', 'B2'), -- pleased / content (formal)
  (206923, 'نامُساعِد', 'B1', 'B2'), -- unfavorable (formal)
  (206924, 'بُزُرگواری', 'B1', 'B2'), -- magnanimity (formal)
  (206925, 'لَپتاپ', 'A1', 'A2'), -- laptop (loanword)
  (206926, 'مُتَقاضی', 'B1', 'B2'), -- applicant (formal)
  (206927, 'تِریبون', 'B1', 'B2'), -- podium / rostrum (loanword)
  (206928, 'مَطرود', 'B2', 'C1'), -- rejected / ostracized (formal)
  (206930, 'موجودیَّت', 'B1', 'B2'), -- existence / entity (formal)
  (206931, 'شَمایِل', 'B2', 'C1'), -- appearance / icon [religious] (formal)
  (206932, 'تَخصیص', 'B1', 'B2'), -- allocation (formal; تخصیص دادن = to allocate)
  (206933, 'تَبصِره', 'B2', 'C1'), -- note / clause [legal, in a bill] (formal)
  (206934, 'دَندانپِزِشک', 'A2', 'B1'), -- dentist
  (206935, 'بَشَردوستانه', 'B1', 'B2'), -- humanitarian (formal)
  (206936, 'تازیانه', 'B2', 'C1'), -- whip / lash (formal)
  (206937, 'حَوضچه', 'A2', 'B1'), -- small pool / basin (formal)
  (206938, 'خودنُما', 'B1', 'B2'), -- showy / ostentatious (formal)
  (206939, 'اِعتِبارنامه', 'B1', 'B2'), -- credentials document (formal)
  (206940, 'پایمال', 'B1', 'B2'), -- trampled [rights violated] (formal; پایمال کردن = to trample)
  (206941, 'سَرگَردانی', 'B1', 'B2'), -- wandering / confusion (formal)
  (206942, 'اِتِّصالی', 'A2', 'B1'), -- short circuit
  (206943, 'مُنفَرِد', 'B1', 'B2'), -- individual / solitary (formal)
  (206944, 'طَبابَت', 'B1', 'B2'), -- medical practice (formal)
  (206945, 'ماتَم', 'B1', 'B2'), -- mourning / grief (formal)
  (206946, 'النگو', 'A2', 'B1'), -- bangle / bracelet
  (206947, 'واهِمه', 'B1', 'B2'), -- fear / apprehension (formal)
  (206948, 'کانگورو', 'A1', 'A2'), -- kangaroo (loanword)
  (206949, 'فِدایی', 'B1', 'B2'), -- devotee / self-sacrificer (formal)
  (206950, 'تَرابَری', 'B1', 'B2'), -- transportation (formal)
  (206951, 'رَمزنِگاری', 'B1', 'B2'), -- cryptography (formal, tech)
  (206952, 'زورگیری', 'B1', 'B2'), -- mugging / robbery (formal)
  (206953, 'بَلوا', 'B1', 'B2'), -- riot / commotion (formal)
  (206954, 'پِلاتین', 'A2', 'B1'), -- platinum (loanword)
  (206955, 'موریانه', 'A2', 'B1'), -- termite
  (206956, 'مَشام', 'B2', 'C1'), -- sense of smell / nostril (formal, literary)
  (206957, 'کُزاز', 'B1', 'B2'), -- tetanus (medical)
  (206958, 'سِیلاب', 'B1', 'B2'), -- flood (formal)
  (206959, 'نُروژی', 'A2', 'B1'), -- Norwegian (nationality)
  (206960, 'رویکَرد', 'B1', 'B2'), -- approach / attitude (formal)
  (206961, 'باغبانی', 'A2', 'B1'), -- gardening (formal)
  (206962, 'توانمَند', 'B1', 'B2'), -- capable / empowered (formal)
  (206963, 'تَرَدُّد', 'B1', 'B2'), -- traffic / commuting (formal)
  (206964, 'مَصلَحَتی', 'B1', 'B2'), -- expedient (formal)
  (206965, 'دوراهی', 'B1', 'B2'), -- crossroads / fork in the road (formal)
  (206966, 'واگُذاری', 'B1', 'B2'), -- transfer / handover (formal)
  (206967, 'رویاپَردازی', 'B1', 'B2'), -- daydreaming / fantasizing (formal)
  (206968, 'مُعضِل', 'B1', 'B2'), -- dilemma / problem (formal)
  (206969, 'خودبینی', 'B2', 'C1'), -- self-centeredness / vanity (formal)
  (206970, 'تَزَلزُل', 'B1', 'B2'), -- instability (formal)
  (206971, 'بیقَراری', 'B1', 'B2'), -- restlessness (formal)
  (206972, 'مُتِداوَل', 'B1', 'B2'), -- common / customary (formal)
  (206973, 'آبپَز', 'A2', 'B1'), -- boiled [food]
  (206974, 'مُختار', 'B1', 'B2'), -- autonomous / authorized (formal)
  (206975, 'ژاندارمَری', 'B2', 'C1'), -- gendarmerie (loanword, historical / military police)
  (206976, 'سُربی', 'B1', 'B2'), -- lead-colored / gray (formal)
  (206977, 'هَمهَمه', 'B1', 'B2'), -- murmur / hubbub [crowd noise] (formal)
  (206978, 'نَشریه', 'B1', 'B2'), -- publication / journal (formal)
  (206979, 'مُفَرِّح', 'B2', 'C1'), -- enjoyable / pleasant (formal)
  (206980, 'نیمرُخ', 'B1', 'B2'), -- profile [side view] (formal)
  (206981, 'نالایِق', 'B1', 'B2'), -- unworthy / incompetent (formal)
  (206982, 'مُکاشِفه', 'B2', 'C1'), -- revelation / discovery (formal)
  (206983, 'نورون', 'B1', 'B2'), -- neuron (loanword, medical)
  (206984, 'خِلافَت', 'B2', 'C1'), -- caliphate (formal, historical / religious)
  (206985, 'خَلّاقیَّت', 'B1', 'B2'), -- creativity (formal)
  (206986, 'حَیثیَّت', 'B1', 'B2'), -- reputation / dignity (formal, legal)
  (206987, 'اَندوهگین', 'B1', 'B2'), -- sorrowful (formal)
  (206988, 'شالوده', 'B1', 'B2'), -- foundation / framework (formal)
  (206989, 'بازنِگَری', 'B1', 'B2'), -- review / revision (formal)
  (206990, 'هیدرولیک', 'B1', 'B2'), -- hydraulic (loanword)
  (206991, 'مَنوال', 'B2', 'C1'), -- manner / way (formal)
  (206992, 'ضَوابِط', 'B1', 'B2'), -- regulations / criteria (formal)
  (206993, 'راستگویی', 'B1', 'B2'), -- truthfulness / honesty (formal)
  (206994, 'خونبَها', 'B2', 'C1'), -- blood money (formal)
  (206996, 'تابِعیَّت', 'B1', 'B2'), -- citizenship / nationality (formal)
  (206997, 'پارانویا', 'B1', 'B2'), -- paranoia (loanword)
  (206998, 'مُشَوِّق', 'B1', 'B2'), -- incentive / encourager (formal)
  (206999, 'غیرمُنصِفانه', 'B1', 'B2'), -- unfair
  (207000, 'روانکاو', 'B1', 'B2'), -- psychoanalyst (formal)
  (207001, 'پوسیدگی', 'B1', 'B2'), -- decay / rot (formal)
  (207002, 'دورِهَمی', 'A2', 'B1'), -- get-together / gathering (informal)
  (207003, 'ناسپاس', 'B1', 'B2'), -- ungrateful (formal)
  (207004, 'پیانیست', 'A2', 'B1'), -- pianist (loanword)
  (207005, 'رَعشه', 'B1', 'B2'), -- tremor / shiver (formal, medical)
  (207006, 'اِرادَت', 'B1', 'B2'), -- devotion / reverence (formal)
  (207007, 'تُربچه', 'A2', 'B1'), -- radish
  (207008, 'فَضیلَت', 'B1', 'B2'), -- virtue (formal)
  (207009, 'دامان', 'B2', 'C1'), -- lap / bosom [figurative] (formal, literary)
  (207010, 'تیرَک', 'A2', 'B1'), -- pole / post (formal)
  (207011, 'روزبِخِیر', 'A1', 'A2'), -- good day!
  (207012, 'مُتِعالی', 'B1', 'B2'), -- transcendent / sublime (formal)
  (207013, 'رَزمَنده', 'B1', 'B2'), -- warrior / combatant (formal)
  (207014, 'سوءقَصد', 'B2', 'C1'), -- assassination attempt (formal)
  (207015, 'پَیوَستگی', 'B1', 'B2'), -- continuity / connection (formal)
  (207016, 'پَهنه', 'B1', 'B2'), -- expanse / area (formal)
  (207017, 'عِمامه', 'A2', 'B1'), -- turban
  (207018, 'پِدَرزَن', 'A2', 'B1'), -- father-in-law [wife's father]
  (207019, 'تَدافُعی', 'B1', 'B2'), -- defensive (formal)
  (207020, 'زائِد', 'B1', 'B2'), -- superfluous / excess (formal)
  (207021, 'اِبتِلا', 'B1', 'B2'), -- affliction / contraction [of disease] (formal)
  (207022, 'سَهمگین', 'B2', 'C1'), -- fierce / severe (formal, literary)
  (207024, 'ناشنوا', 'B1', 'B2'), -- deaf (formal)
  (207025, 'مایکروویو', 'A2', 'B1'), -- microwave (loanword)
  (207026, 'مَعصومیَّت', 'B1', 'B2'), -- innocence (formal)
  (207027, 'زیرساخت', 'B1', 'B2'), -- infrastructure (formal)
  (207029, 'زائِر', 'B1', 'B2'), -- pilgrim (formal)
  (207030, 'پیاله', 'A2', 'B1'), -- small bowl / cup (formal)
  (207031, 'خُروش', 'B2', 'C1'), -- roar / outcry (formal)
  (207032, 'اَساسنامه', 'B2', 'C1'), -- bylaws / charter (formal, legal)
  (207033, 'سَگَک', 'A2', 'B1'), -- buckle
  (207034, 'مُبتَنی', 'B1', 'B2'), -- based on (formal)
  (207035, 'شَطرَنجی', 'A2', 'B1'), -- checkered / plaid pattern
  (207036, 'آبپاش', 'A2', 'B1'), -- watering can / sprinkler
  (207037, 'والامَقام', 'B2', 'C1'), -- high-ranking / exalted (formal)
  (207038, 'تیرِگی', 'B1', 'B2'), -- darkness / gloominess (formal)
  (207039, 'سِپِهر', 'B2', 'C1'), -- sky / celestial sphere (formal, literary)
  (207040, 'زیرسیگاری', 'A2', 'B1'), -- ashtray
  (207041, 'تَقابُل', 'B1', 'B2'), -- confrontation / opposition (formal)
  (207042, 'هولوگرام', 'A2', 'B1'), -- hologram (loanword)
  (207043, 'مُلتَهِب', 'B2', 'C1'), -- inflamed (formal, medical)
  (207044, 'شایان', 'B1', 'B2'), -- worthy / deserving (formal)
  (207045, 'شُگون', 'B1', 'B2'), -- omen (formal, literary)
  (207046, 'بانُفوذ', 'B1', 'B2'), -- influential (formal)
  (207047, 'چگال', 'B1', 'B2'), -- dense (formal, physics)
  (207048, 'مُساعَدَت', 'B1', 'B2'), -- assistance / help (formal)
  (207049, 'پُرمَشغَله', 'B1', 'B2'), -- busy / occupied (formal)
  (207050, 'هَمدَرد', 'B1', 'B2'), -- fellow sufferer / sympathizer (formal)
  (207051, 'مِتکا', 'A2', 'B1'), -- pillow / cushion (formal)
  (207052, 'مَتلَک', 'B1', 'B2'), -- taunt / innuendo (informal)
  (207053, 'زُلال', 'B1', 'B2'), -- clear / pure [water] (formal)
  (207054, 'مِتُد', 'A2', 'B1'), -- method (loanword)
  (207055, 'عُطارِد', 'A2', 'B1'), -- Mercury [planet]
  (207056, 'اُفول', 'B1', 'B2'), -- decline / wane (formal)
  (207057, 'لِگدمال', 'B2', 'C1'), -- trampled (formal)
  (207058, 'اِستِبداد', 'B1', 'B2'), -- tyranny / despotism (formal)
  (207059, 'مَسئولانه', 'B1', 'B2'), -- responsibly (formal)
  (207060, 'دیدبانی', 'B2', 'C1'), -- lookout / surveillance (formal, military)
  (207061, 'گُستَره', 'B1', 'B2'), -- scope / extent (formal)
  (207062, 'مُخبِر', 'B1', 'B2'), -- informant (formal)
  (207063, 'تَسبیح', 'A2', 'B1'), -- prayer beads
  (207064, 'نَجِس', 'B1', 'B2'), -- impure / unclean [religious] (formal)
  (207065, 'گوشتخوار', 'A2', 'B1'), -- carnivore
  (207066, 'دِلخَراش', 'B1', 'B2'), -- heart-wrenching (formal)
  (207067, 'مُشتَق', 'B2', 'C1'), -- derivative (formal, math / linguistics)
  (207068, 'مُعَدَّل', 'B1', 'B2'), -- GPA / average grade (formal, academic)
  (207069, 'تَپنده', 'B1', 'B2'), -- beating / pulsating [heart] (formal)
  (207070, 'بومِرَنگ', 'A2', 'B1'), -- boomerang (loanword)
  (207071, 'فالگیر', 'B1', 'B2'), -- fortune teller (formal)
  (207072, 'بَدنامی', 'B1', 'B2'), -- notoriety / infamy (formal)
  (207073, 'مَقوله', 'B1', 'B2'), -- category / topic (formal)
  (207074, 'مُنَزَّه', 'B2', 'C1'), -- pure / immaculate (formal)
  (207075, 'اِحتِساب', 'B1', 'B2'), -- calculation / taking into account (formal)
  (207076, 'قاطِعیَّت', 'B1', 'B2'), -- decisiveness (formal)
  (207077, 'خویشتَن', 'B2', 'C1'), -- self [formal literary reflexive]
  (207078, 'پالایِشگاه', 'B1', 'B2'), -- refinery (formal)
  (207079, 'مَغشوش', 'B2', 'C1'), -- confused / disturbed (formal)
  (207080, 'مُتَوَلّی', 'B2', 'C1'), -- custodian / trustee (formal)
  (207081, 'بُنیادی', 'B1', 'B2'), -- fundamental / basic (formal)
  (207082, 'سُتوه', 'B2', 'C1'), -- exasperation (formal; به ستوه آمدن = to be fed up)
  (207083, 'توربین', 'A2', 'B1'), -- turbine (loanword)
  (207084, 'مُناجات', 'B2', 'C1'), -- supplication / prayer (formal, literary)
  (207085, 'غِلظَت', 'B1', 'B2'), -- concentration / density [chemistry] (formal)
  (207086, 'نِقابدار', 'B1', 'B2'), -- masked (formal)
  (207087, 'اِلزامی', 'B1', 'B2'), -- mandatory (formal)
  (207088, 'عِفَّت', 'B2', 'C1'), -- chastity / modesty (formal)
  (207089, 'تِزار', 'B1', 'B2'), -- tsar (loanword, historical)
  (207090, 'کِذب', 'B2', 'C1'), -- falsehood / lie (formal, legal)
  (207091, 'سودآوَر', 'B1', 'B2'), -- profitable (formal)
  (207092, 'مُضاعَف', 'B1', 'B2'), -- doubled / redoubled (formal)
  (207093, 'وَحدَت', 'B1', 'B2'), -- unity (formal)
  (207094, 'دَستخوش', 'B1', 'B2'), -- subjected to / victim of (formal)
  (207095, 'نانوایی', 'A2', 'B1'), -- bakery
  (207096, 'هَمدَستی', 'B1', 'B2'), -- complicity / collaboration (formal)
  (207097, 'عُمدَتاً', 'B1', 'B2'), -- mainly (formal)
  (207098, 'پالایِش', 'B1', 'B2'), -- refining / purification (formal)
  (207099, 'دَماسَنج', 'A2', 'B1'), -- thermometer
  (207100, 'سِمساری', 'B1', 'B2'), -- secondhand shop (formal)
  (207101, 'حاکِمیَّت', 'B1', 'B2'), -- sovereignty (formal)
  (207102, 'پویا', 'B1', 'B2'), -- dynamic (formal)
  (207103, 'غیرِرَسمی', 'B1', 'B2'), -- unofficial / informal
  (207104, 'پُرافتِخار', 'B1', 'B2'), -- full of honors / glorious (formal)
  (207105, 'عِنایَت', 'B2', 'C1'), -- favor / grace (formal, religious / literary)
  (207106, 'سَختگیرانه', 'B1', 'B2'), -- strictly (formal)
  (207107, 'نَوازَندگی', 'B1', 'B2'), -- musicianship (formal)
  (207108, 'تَسهیلات', 'B1', 'B2'), -- facilities / amenities (formal)
  (207109, 'گیتاریست', 'A2', 'B1'), -- guitarist (loanword)
  (207110, 'حَلوا', 'A2', 'B1'), -- halva
  (207111, 'رَنجور', 'B2', 'C1'), -- suffering / afflicted (formal)
  (207112, 'جَوانمَرد', 'B1', 'B2'), -- chivalrous (formal)
  (207113, 'سَرراست', 'B1', 'B2'), -- straightforward (formal)
  (207114, 'عَزیمَت', 'B2', 'C1'), -- departure (formal)
  (207115, 'بیراهه', 'B1', 'B2'), -- wrong path / detour (formal)
  (207116, 'مُتِقاعِدکُننده', 'B1', 'B2'), -- convincing (formal)
  (207117, 'کاتالیزور', 'B1', 'B2'), -- catalyst (loanword, chemistry)
  (207118, 'پیشگیرانه', 'B1', 'B2'), -- preventive (formal)
  (207119, 'چَرخدار', 'A2', 'B1'), -- wheeled (formal)
  (207121, 'گُلچین', 'B1', 'B2'), -- selection / anthology (formal)
  (207122, 'هَدفگیری', 'B1', 'B2'), -- aiming / targeting (formal)
  (207123, 'آیتِم', 'A2', 'B1'), -- item (loanword)
  (207124, 'پَکیج', 'A2', 'B1'), -- package (loanword)
  (207126, 'گِلاویز', 'B1', 'B2'), -- grappling / wrestling [figurative] (formal)
  (207127, 'زِراعَت', 'B1', 'C1'), -- agriculture / farming (formal)
  (207128, 'بینَوا', 'B2', 'C1'), -- poor / destitute (formal, literary)
  (207129, 'گوشمالی', 'B1', 'B2'), -- reprimand / spanking (formal, idiomatic)
  (207130, 'تَوَکُّل', 'B2', 'C1'), -- trust [in God] (formal, religious)
  (207131, 'تَغییرشَکل', 'B1', 'B2'), -- deformation / transformation (formal)
  (207132, 'اَبَرانسان', 'B1', 'B2'), -- superhuman (formal)
  (207133, 'هَزارپا', 'A2', 'B1'), -- centipede
  (207134, 'نَدامَتگاه', 'B2', 'C1'), -- prison / penitentiary (formal)
  (207135, 'رِهاسازی', 'B1', 'B2'), -- release / liberation (formal)
  (207136, 'صَنوبَر', 'B2', 'C1'), -- pine / fir tree (formal)
  (207137, 'حائِل', 'B1', 'C1'), -- barrier / partition (formal)
  (207138, 'اَرجَحیَّت', 'B1', 'B2'), -- priority / preference (formal)
  (207139, 'پَرهیزکار', 'B1', 'B2'), -- pious / devout (formal)
  (207140, 'فیزیوتِراپی', 'B1', 'B2'), -- physiotherapy (loanword)
  (207141, 'مُتَخاصِم', 'B2', 'C1'), -- hostile / belligerent (formal)
  (207142, 'مَتانَت', 'B2', 'C1'), -- dignity / composure (formal)
  (207143, 'مُزَیَّن', 'B1', 'B2'), -- adorned (formal)
  (207144, 'قَعر', 'B1', 'C1'), -- depths / bottom (formal)
  (207145, 'فَرمانبَردار', 'B1', 'C1'), -- obedient / submissive (formal)
  (207146, 'حُقوقدان', 'B1', 'C1'), -- jurist / legal scholar (formal)
  (207147, 'گُنجایِش', 'B1', 'B2'), -- capacity (formal)
  (207148, 'بَرانداز', 'B2', 'C1'), -- overthrower / subversive (formal)
  (207149, 'شیمیدان', 'B1', 'B2'), -- chemist (formal)
  (207150, 'هُشیاری', 'B1', 'B2'), -- alertness (formal)
  (207151, 'ذَبح', 'B1', 'B2'), -- slaughter [ritual] (formal)
  (207152, 'بینَظیر', 'B1', 'B2'), -- unparalleled / matchless (formal)
  (207153, 'فَضل', 'B2', 'C1'), -- virtue / excellence [scholarly] (formal)
  (207154, 'اِستِعمال', 'B1', 'B2'), -- usage / consumption (formal)
  (207155, 'ریاضَت', 'B2', 'C1'), -- asceticism / austerity (formal)
  (207156, 'خودمُختار', 'B1', 'B2'), -- autonomous / self-governing (formal)
  (207157, 'مُعافیَّت', 'B1', 'B2'), -- exemption (formal)
  (207158, 'اُرگانیسم', 'B1', 'B2'), -- organism (loanword)
  (207159, 'بیضی', 'A2', 'B1'), -- oval / ellipse (formal, geometry)
  (207160, 'سَرخورده', 'B1', 'C1'), -- disillusioned / frustrated (formal)
  (207161, 'خَطاکار', 'B1', 'B2'), -- wrongdoer / culprit (formal)
  (207162, 'بیخانمان', 'B1', 'B2'), -- homeless (formal)
  (207163, 'هَموَطَن', 'B1', 'C1'), -- compatriot (formal)
  (207164, 'بِویژه', 'B1', 'B2'), -- especially (formal)
  (207165, 'آغازین', 'B1', 'B2'), -- initial (formal)
  (207166, 'عَریض', 'B1', 'B2'), -- wide / broad (formal)
  (207167, 'بُزُرگنَمایی', 'B1', 'B2'), -- magnification / exaggeration (formal)
  (207168, 'رومانیایی', 'A2', 'B1'), -- Romanian (nationality)
  (207169, 'دوشاخه', 'A2', 'B1'), -- plug [electrical]; fork
  (207170, 'مَلزومات', 'B1', 'B2'), -- requirements / necessities (formal)
  (207171, 'تَجَمُّلات', 'B1', 'C1'), -- luxuries (formal)
  (207172, 'مؤمِن', 'B1', 'C1'), -- believer / faithful (formal, religious)
  (207173, 'مَوقوف', 'B1', 'C1'), -- suspended / halted (formal)
  (207174, 'غیرمُسَلَّح', 'B1', 'B2'), -- unarmed
  (207175, 'پیشتَر', 'B1', 'B2'), -- earlier / previously (formal)
  (207176, 'سَرفراز', 'B2', 'C1'), -- proud / honored [head held high] (formal)
  (207177, 'ناسالِم', 'B1', 'C1'), -- unhealthy
  (207178, 'آزادسازی', 'B1', 'B2'), -- liberation / freeing (formal)
  (207179, 'تَبَعه', 'B1', 'C1'), -- subject / national [citizen] (formal)
  (207180, 'زَنانِگی', 'B1', 'B2'), -- femininity (formal)
  (207181, 'کَتف', 'A2', 'B1'), -- shoulder blade (formal)
  (207182, 'طَراوَت', 'B2', 'C1'), -- freshness (formal, literary)
  (207183, 'صِرب', 'A2', 'B1'), -- Serb (nationality)
  (207184, 'پیغامگیر', 'A2', 'B1'), -- answering machine / voicemail
  (207185, 'پیشقَدَم', 'B1', 'B2'), -- pioneer / one who takes the first step (formal)
  (207186, 'حاصِلخیز', 'B1', 'B2'), -- fertile [land] (formal)
  (207187, 'اِستیضاح', 'B2', 'C1'), -- interpellation / impeachment [political] (formal)
  (207188, 'هَمنِشینی', 'B1', 'B2'), -- companionship / association (formal)
  (207189, 'مُستَجاب', 'B2', 'C1'), -- answered [prayer] (formal, religious)
  (207190, 'تَبَحُّر', 'B1', 'B2'), -- expertise / mastery (formal)
  (207191, 'مُکاتِبات', 'B1', 'C1'), -- correspondence [letters] (formal)
  (207192, 'صامِت', 'B1', 'C1'), -- consonant [linguistics]
  (207193, 'مُفرِط', 'B1', 'C1'), -- excessive (formal)
  (207194, 'بَرحَسَب', 'B1', 'C1'), -- according to / based on (formal)
  (207195, 'هُبوط', 'B2', 'C1'), -- descent / fall [religious] (formal)
  (207196, 'ناشایَست', 'B1', 'B2'), -- unbecoming / improper (formal)
  (207197, 'اِفتِرا', 'B1', 'C1'), -- slander / defamation (formal, legal)
  (207198, 'سُروده', 'B1', 'C1'), -- poem / composed [verse] (formal)
  (207199, 'سَنجیده', 'B1', 'B2'), -- deliberate / well-considered (formal)
  (207200, 'تَزئینات', 'B1', 'B2'), -- decorations (formal)
  (207201, 'جاعِل', 'B1', 'C1'), -- forger (formal, legal)
  (207202, 'شَرع', 'B1', 'C1'), -- Islamic law / religious law (formal)
  (207203, 'پُرسِشنامه', 'B1', 'C1'), -- questionnaire (formal)
  (207204, 'گُوارِشی', 'B1', 'B2'), -- digestive (formal)
  (207205, 'مانتو', 'A1', 'A2'), -- manteau / overcoat (loanword)
  (207206, 'اِذعان', 'B1', 'C1'), -- admission / acknowledgment (formal)
  (207207, 'مُراعات', 'B1', 'C1'), -- consideration / observance [of rules] (formal)
  (207208, 'مُوَقَّر', 'B2', 'C1'), -- dignified / venerable (formal)
  (207209, 'شَقیقه', 'B1', 'B2'), -- temple [side of head] (formal)
  (207210, 'کروموزوم', 'A2', 'B1'), -- chromosome (loanword)
  (207211, 'پَرخاش', 'B1', 'C1'), -- aggression / outburst (formal)
  (207212, 'آلیاژ', 'B1', 'B2'), -- alloy (formal)
  (207213, 'مُستَمِر', 'B1', 'C1'), -- continuous / ongoing (formal)
  (207214, 'اُستواری', 'B1', 'C1'), -- firmness / steadfastness (formal)
  (207215, 'مُتِوازِن', 'B1', 'C1'), -- balanced (formal)
  (207217, 'تَشویش', 'B1', 'B2'), -- anxiety / worry (formal)
  (207218, 'مُتِقارِن', 'B1', 'C1'), -- symmetrical (formal)
  (207219, 'مَفاد', 'B1', 'B2'), -- provisions / contents [legal document] (formal)
  (207220, 'حَمّالی', 'B1', 'B2'), -- portering / work of carrying loads (formal)
  (207221, 'لوسیون', 'A2', 'B1'), -- lotion (loanword)
  (207222, 'هَمدَسته', 'B1', 'C1'), -- accomplice (formal)
  (207223, 'بُرجَک', 'B1', 'B2'), -- turret / small tower
  (207224, 'اِختِلافی', 'B1', 'B2'), -- controversial / disputed (formal)
  (207225, 'سَرازیری', 'B1', 'B2'), -- downhill slope (formal)
  (207226, 'پِنداری', 'B1', 'B2'), -- as if / seemingly (formal, literary)
  (207227, 'نِشاسته', 'A2', 'B1'), -- starch
  (207228, 'صیقَل', 'B1', 'B2'), -- polish / sheen (formal; صیقل دادن = to polish)
  (207229, 'اَوامِر', 'B1', 'C1'), -- orders / commands (formal, plural of امر)
  (207230, 'آویزه', 'B1', 'B2'), -- pendant / earring (formal)
  (207231, 'پَرتودَرمانی', 'B2', 'C1'), -- radiotherapy (medical)
  (207232, 'اِنتِقالات', 'B1', 'C1'), -- transfers (formal)
  (207233, 'نابَخشودَنی', 'B1', 'B2'), -- unforgivable (formal)
  (207234, 'اَخلاقیّات', 'B1', 'B2'), -- ethics / morals (formal)
  (207235, 'اولنا', 'B2', 'C1'), -- ulna [forearm bone] (medical, loanword)
  (207236, 'تَکاپو', 'B1', 'C1'), -- endeavor / bustling activity (formal, literary)
  (207237, 'ناخُنَک', 'B1', 'B2'), -- pterygium [eye condition]; nibbling at food (formal; ناخنک زدن = to pick at)
  (207238, 'تیروکَمان', 'A2', 'B1'), -- bow and arrow
  (207239, 'فَرآوَرده', 'B1', 'C1'), -- product / produce (formal)
  (207240, 'هَمزیستی', 'B1', 'B2'), -- coexistence (formal)
  (207241, 'خوشنودی', 'B1', 'B2'), -- satisfaction / contentment (formal)
  (207243, 'کریستالی', 'B1', 'B2'), -- crystalline (loanword)
  (207244, 'مُتِفَکِّرانه', 'B1', 'C1'), -- thoughtfully (formal)
  (207245, 'جَعفَری', 'A1', 'A2'), -- parsley
  (207246, 'اِشکالات', 'B1', 'B2'), -- problems / flaws (formal, plural of اشکال)
  (207247, 'آنکه', 'B2', 'C1'), -- that which / the one that (formal, literary)
  (207250, 'جاگُذاری', 'B1', 'B2'), -- placement / positioning (formal)
  (207251, 'کَلاف', 'B1', 'C1'), -- skein / tangle [of yarn] (formal)
  (207252, 'مُنحَصِراً', 'B1', 'B2'), -- exclusively (formal)
  (207253, 'سَهامدار', 'B1', 'C1'), -- shareholder (formal)
  (207254, 'تیتانیوم', 'A2', 'B1'), -- titanium (loanword)
  (207255, 'خُرمایی', 'B1', 'B2'), -- date-colored / brown (formal)
  (207256, 'کُدورَت', 'B1', 'B2'), -- resentment / ill feeling (formal)
  (207257, 'مُسری', 'B1', 'B2'), -- contagious (formal)
  (207258, 'اِتانول', 'B1', 'C1'), -- ethanol (loanword, chemistry)
  (207259, 'هُشیار', 'B1', 'B2'), -- alert / conscious (formal)
  (207260, 'مَسروقه', 'B2', 'C1'), -- stolen [legal term] (formal)
  (207261, 'پَرَستِشگاه', 'B1', 'C1'), -- place of worship (formal)
  (207262, 'اِنشِقاق', 'C1', 'C2'), -- schism / split (formal, rare)
  (207264, 'جِلگه', 'B1', 'C1'), -- plain / lowland [geography] (formal)
  (207266, 'رَمّال', 'B1', 'B2'), -- fortune-teller (formal)
  (207267, 'مَرحَبا', 'A2', 'B1'), -- welcome! / hello! (formal, Arabic loan)
  (207268, 'نَسیه', 'B1', 'B2'), -- credit [purchase on credit] (formal)
  (207269, 'تَقاضانامه', 'B1', 'C1'), -- application form (formal)
  (207270, 'آدَمکُشی', 'B1', 'B2'), -- murder / homicide (formal)
  (207271, 'تُخمه', 'A1', 'A2'), -- seeds [sunflower/watermelon snack]
  (207272, 'مودِم', 'A2', 'B1'), -- modem (loanword)
  (207273, 'لِجاجَت', 'B1', 'C1'), -- stubbornness / obstinacy (formal)
  (207274, 'جُذام', 'B2', 'C1'), -- leprosy (medical)
  (207275, 'آبِلیسک', 'B1', 'C1'), -- obelisk (loanword)
  (207276, 'مُفَتِّش', 'B1', 'B2'), -- inspector [police/investigator] (formal)
  (207277, 'اِصطِکاک', 'B1', 'B2'), -- friction (formal)
  (207278, 'دِلیجان', 'B1', 'B2'), -- stagecoach (formal)
  (207279, 'پاکُن', 'A1', 'A2'), -- eraser
  (207280, 'بافَندگی', 'B1', 'B2'), -- weaving [craft] (formal)
  (207281, 'خُرافه', 'B1', 'C1'), -- superstition (formal)
  (207282, 'جَهالَت', 'B1', 'C1'), -- ignorance (formal)
  (207283, 'زاهِد', 'B2', 'C1'), -- ascetic / pious hermit (formal)
  (207284, 'مُسافِربَری', 'B1', 'B2'), -- passenger-carrying / passenger transport (formal)
  (207285, 'مُعارَفه', 'B1', 'C1'), -- introduction ceremony / getting acquainted (formal)
  (207286, 'مَنقَل', 'B1', 'C1'), -- brazier / charcoal grill (formal)
  (207287, 'مَنهایِ', 'A2', 'B1'), -- minus [math]
  (207288, 'اِپیزود', 'A2', 'B1'), -- episode (loanword)
  (207289, 'نَوانخانه', 'B2', 'C1'), -- poorhouse / almshouse (formal)
  (207290, 'آلبانیایی', 'A2', 'B1'), -- Albanian (nationality)
  (207291, 'خَزیدَن', 'B1', 'B2'), -- to crawl / to creep
  (207292, 'نامُطمَئِن', 'B1', 'C1'), -- uncertain / unsure (formal)
  (207293, 'اِستِطاعَت', 'B2', 'C1'), -- capability / financial means (formal)
  (207294, 'کاردان', 'B1', 'C1'), -- skilled / competent (formal)
  (207295, 'اِرعاب', 'B2', 'C1'), -- intimidation (formal)
  (207297, 'نِثار', 'B1', 'C1'), -- offering / bestowal [flowers etc.] (formal)
  (207298, 'سَلمانی', 'A2', 'B1'), -- barber shop
  (207299, 'گَدایی', 'B1', 'B2'), -- begging (formal)
  (207300, 'بَرانکار', 'B1', 'B2'), -- stretcher [medical] (loanword)
  (207301, 'وَسواسی', 'B1', 'B2'), -- obsessive (formal)
  (207302, 'کَدخُدا', 'B1', 'C1'), -- village chief (formal)
  (207303, 'هَندَسی', 'B1', 'B2'), -- geometric (formal)
  (207304, 'بی‌شُماری', 'B1', 'B2'), -- countless (formal)
  (207305, 'اِستریو', 'A2', 'B1'), -- stereo (loanword)
  (207306, 'لوکوموتیو', 'B1', 'B2'), -- locomotive (loanword)
  (207307, 'واقِف', 'B1', 'C1'), -- aware / cognizant (formal; واقف بودن = to be aware)
  (207308, 'سَراسیمه', 'B1', 'B2'), -- flustered / panicked (formal)
  (207309, 'نِهال', 'A2', 'B1'), -- sapling
  (207310, 'سیلیکون', 'B1', 'B2'), -- silicon (loanword)
  (207311, 'کُرکی', 'B1', 'B2'), -- fluffy / downy (formal)
  (207312, 'کِفّه', 'B1', 'B2'), -- pan [of a scale] (formal)
  (207313, 'کِمیابی', 'B1', 'B2'), -- scarcity / rarity (formal)
  (207314, 'بِلورین', 'B2', 'C1'), -- crystal / made of crystal (formal, literary)
  (207315, 'سِپاهی', 'B1', 'B2'), -- soldier / military member (formal)
  (207316, 'بِسان', 'B2', 'C1'), -- like / similar to (formal, literary)
  (207317, 'پَسرَفت', 'B1', 'C1'), -- regression / setback (formal)
  (207318, 'هَمخون', 'B1', 'B2'), -- blood relative / of the same blood (formal)
  (207319, 'مَسنَد', 'B1', 'C1'), -- seat / position [of power] (formal)
  (207320, 'تِراموا', 'A2', 'B1'), -- tram (loanword)
  (207321, 'پیشبَند', 'A2', 'B1'), -- apron / bib
  (207322, 'غَیرِاَخلاقی', 'B1', 'B2'), -- immoral / unethical (formal)
  (207323, 'آپاندیس', 'B1', 'B2'), -- appendix [organ] (medical, loanword)
  (207324, 'بی‌فایده', 'A2', 'B1'), -- useless
  (207325, 'یِک‌ساله', 'A2', 'B1'), -- one-year-old / annual
  (207326, 'سَربار', 'B1', 'B2'), -- burden / overhead (formal)
  (207327, 'پیچَک', 'A2', 'B1'), -- ivy [plant]
  (207328, 'دَلو', 'B1', 'C1'), -- Aquarius [zodiac] / bucket (formal)
  (207329, 'گیتی', 'B2', 'C1'), -- world / universe (formal, literary)
  (207330, 'دَندانپِزِشکی', 'A2', 'B1'), -- dentistry
  (207331, 'قِصاص', 'B2', 'C1'), -- retribution / retaliation (formal, legal)
  (207332, 'سیزدَهُمین', 'A2', 'B1'), -- thirteenth [ordinal]
  (207333, 'پُررَنگ', 'B1', 'C1'), -- bold / strong [color] (formal)
  (207334, 'کَلامی', 'B2', 'C1'), -- verbal / theological (formal)
  (207335, 'بَزَنگاه', 'B1', 'C1'), -- critical moment (formal)
  (207336, 'زائو', 'B2', 'C1'), -- woman in childbirth / postpartum woman (formal, medical)
  (207337, 'چَپاوَل', 'B1', 'C1'), -- plunder / pillage (formal)
  (207338, 'گُلاب', 'A2', 'B1'), -- rosewater
  (207339, 'هَرگاه', 'B1', 'C1'), -- whenever (formal)
  (207340, 'آرمیده', 'B2', 'C1'), -- at rest / settled (formal, literary)
  (207341, 'سانس', 'B1', 'C1'), -- showtime [movie] / session (loanword)
  (207342, 'خَراج', 'B2', 'C1'), -- land tax [historical] (formal)
  (207343, 'بِهزیستی', 'B1', 'B2'), -- welfare [social welfare] (formal)
  (207344, 'بِهینه', 'B1', 'B2'), -- optimal (formal)
  (207345, 'تَخریبی', 'B1', 'B2'), -- destructive (formal)
  (207346, 'اِبتِکاری', 'B1', 'B2'), -- innovative (formal)
  (207347, 'تَحصیل‌کَرده', 'B1', 'B2'), -- educated (formal)
  (207348, 'اِرتِعاشات', 'B1', 'C1'), -- vibrations (formal)
  (207349, 'هَتک', 'B2', 'C1'), -- violation [of honor/dignity] (formal, legal)
  (207350, 'اِحداث', 'B1', 'C1'), -- construction / establishment (formal)
  (207353, 'رَهایِش', 'B1', 'B2'), -- release / letting go (formal)
  (207354, 'خَبَرنِگاری', 'B1', 'B2'), -- journalism (formal)
  (207355, 'آلبالو', 'A1', 'A2'), -- sour cherry
  (207356, 'بی‌طَرَف', 'B1', 'B2'), -- neutral / impartial (formal)
  (207357, 'صیغه', 'B2', 'C1'), -- temporary marriage [Islamic legal term] (formal)
  (207358, 'لَزج', 'B1', 'C1'), -- slimy / viscous (formal)
  (207359, 'رَجَز', 'C1', 'C2'), -- boasting / vaunting [esp. before battle] (formal, rare)
  (207361, 'پِلاتینیوم', 'B1', 'C1'), -- platinum (loanword)
  (207362, 'پاینده', 'B2', 'C1'), -- everlasting / enduring (formal, literary)
  (207363, 'سِمفونی', 'B1', 'B2'), -- symphony (loanword)
  (207364, 'مُکتَشِف', 'B2', 'C1'), -- discoverer / explorer (formal)
  (207365, 'نَوارچِسب', 'A2', 'B1'), -- adhesive tape
  (207366, 'آن‌گونه', 'B2', 'C1'), -- in that manner (formal, literary)
  (207367, 'اَژدَر', 'B1', 'B2'), -- torpedo (formal)
  (207368, 'کریل', 'B1', 'B2'), -- krill (loanword, marine biology)
  (207370, 'چَرخان', 'B1', 'C1'), -- rotating / spinning (formal)
  (207371, 'گُلگونه', 'B2', 'C1'), -- rouge / blush [cosmetic] (formal, literary)
  (207372, 'نَذر', 'B1', 'C1'), -- vow / votive offering (formal, religious)
  (207374, 'دِگَرگونی', 'B1', 'B2'), -- transformation / change (formal)
  (207375, 'غَرایِز', 'B1', 'B2'), -- instincts (formal, plural of غریزه)
  (207376, 'سَمعَک', 'B1', 'B2'), -- hearing aid
  (207378, 'دُکترین', 'B2', 'C1'), -- doctrine (loanword)
  (207379, 'نَهضَت', 'B1', 'C1'), -- movement [political/social] (formal)
  (207380, 'دِهقان', 'B1', 'C1'), -- peasant / farmer (formal)
  (207381, 'اِنزِجار', 'B1', 'C1'), -- disgust / revulsion (formal)
  (207382, 'اِسپیکِر', 'A2', 'B1'), -- speaker [audio device] (loanword)
  (207384, 'مؤَسِّس', 'B1', 'C1'), -- founder (formal)
  (207385, 'شاهراه', 'B1', 'C1'), -- highway / main road (formal)
  (207387, 'اِنحِطاط', 'B2', 'C1'), -- decline / decadence (formal)
  (207388, 'مَضیقه', 'B2', 'C1'), -- predicament / tight spot (formal)
  (207389, 'نِشاندِهَنده', 'B1', 'C1'), -- indicative / indicator (formal)
  (207390, 'تَندُرُستی', 'B1', 'C1'), -- good health / wellness (formal)
  (207391, 'چَهارپا', 'B1', 'C1'), -- quadruped (formal)
  (207392, 'مَحجوب', 'B2', 'C1'), -- shy / modest (formal)
  (207393, 'تِرِدمیل', 'A2', 'B1'), -- treadmill (loanword)
  (207394, 'رازدار', 'B1', 'C1'), -- confidant / keeper of secrets (formal)
  (207395, 'اُصولی', 'B1', 'B2'), -- principled / methodical (formal)
  (207396, 'مُثَلَّثات', 'B1', 'C1'), -- trigonometry (formal)
  (207397, 'آتِش‌زا', 'B1', 'C1'), -- flammable / incendiary (formal)
  (207399, 'دورُبُرد', 'B1', 'C1'), -- long-range (formal)
  (207400, 'مَسیحا', 'B2', 'C1'), -- Messiah (formal, religious)
  (207401, 'کیبورد', 'A2', 'B1'), -- keyboard (loanword)
  (207402, 'اَرزانی', 'B1', 'B2'), -- cheapness / affordability (formal)
  (207403, 'کاهِنه', 'B2', 'C1'), -- priestess (formal)
  (207404, 'نَمایانگَر', 'B1', 'B2'), -- indicative of / representative (formal)
  (207405, 'بَندِگان', 'B2', 'C1'), -- servants / worshippers [of God] (formal, religious)
  (207406, 'دورویی', 'B1', 'B2'), -- hypocrisy / duplicity (formal)
  (207407, 'دِلاوَرانه', 'B2', 'C1'), -- bravely / valiantly (formal)
  (207408, 'عَتیق', 'B1', 'B2'), -- antique / ancient (formal)
  (207409, 'خَیرخواهی', 'B1', 'B2'), -- benevolence / well-wishing (formal)
  (207410, 'مَخروط', 'B1', 'C1'), -- cone [geometry] (formal)
  (207411, 'بادبِزَن', 'A2', 'B1'), -- hand fan
  (207412, 'تَشریفاتی', 'B1', 'B2'), -- ceremonial / protocol-related (formal)
  (207413, 'گَندُمی', 'B1', 'B2'), -- wheat-colored (formal)
  (207414, 'خَراشیده', 'B1', 'C1'), -- scratched (formal)
  (207415, 'بیوشیمی', 'B1', 'B2'), -- biochemistry
  (207416, 'مازاد', 'B1', 'C1'), -- surplus (formal)
  (207417, 'مُستَبِد', 'B1', 'C1'), -- tyrant / despot (formal)
  (207419, 'گَرانِشی', 'B1', 'B2'), -- gravitational (formal)
  (207421, 'یَهودیَّت', 'B1', 'B2'), -- Judaism (formal)
  (207422, 'عَلامَت‌گُذاری', 'B1', 'B2'), -- punctuation / marking (formal)
  (207423, 'سالیانه', 'B1', 'B2'), -- annual / yearly (formal)
  (207424, 'پِرینتِر', 'A2', 'B1'), -- printer (loanword)
  (207425, 'اُتراق', 'B2', 'C1'), -- encampment / stopping [for rest] (formal)
  (207426, 'گِلیم', 'A2', 'B1'), -- kilim [woven rug]
  (207427, 'بُردباری', 'B1', 'B2'), -- patience / forbearance (formal)
  (207428, 'کُپه', 'B1', 'B2'), -- pile / heap (formal)
  (207429, 'ایدئولوژی', 'B1', 'B2'), -- ideology (loanword)
  (207430, 'شُکرگُزاری', 'B1', 'B2'), -- thanksgiving / gratitude (formal)
  (207431, 'جاخالی', 'B1', 'B2'), -- dodge / feint (formal; جاخالی دادن = to dodge)
  (207432, 'اَخذ', 'B1', 'C1'), -- acquisition / obtaining (formal)
  (207433, 'نامُتِعارَف', 'B1', 'C1'), -- unconventional (formal)
  (207434, 'رَسول', 'B2', 'C1'), -- messenger / prophet (formal, religious)
  (207435, 'خَیرات', 'B1', 'C1'), -- charity / alms (formal, religious)
  (207436, 'اِتِّساع', 'C1', 'C2'), -- expansion / dilation (formal, rare)
  (207437, 'عَلیحَضرَت', 'B2', 'C1'), -- His/Her Majesty (formal, royal title)
  (207439, 'لابراتوار', 'B1', 'C1'), -- laboratory (loanword)
  (207440, 'عِفریته', 'B2', 'C1'), -- hag / witch (formal, derogatory)
  (207441, 'عِبادَتگاه', 'B1', 'C1'), -- place of worship (formal)
  (207442, 'فُرورَفتِگی', 'B1', 'B2'), -- indentation / dent (formal)
  (207443, 'اِشتِراکی', 'B1', 'B2'), -- shared / collective (formal)
  (207444, 'اُستُخوانی', 'B1', 'B2'), -- bony / skeletal (formal)
  (207446, 'شاباش', 'B1', 'C1'), -- bravo! / well done! (also: gift money at celebrations)
  (207447, 'رَغبَت', 'B1', 'C1'), -- desire / inclination (formal)
  (207448, 'لوستِر', 'A2', 'B1'), -- chandelier (loanword)
  (207449, 'مَنسوب', 'B1', 'C1'), -- attributed / ascribed (formal)
  (207450, 'تَرساندَن', 'B1', 'B2'), -- to frighten / to scare
  (207451, 'فِلافِل', 'A2', 'B1'), -- falafel
  (207452, 'عَطف', 'B2', 'C1'), -- reference / turning [formal; عطف به]
  (207453, 'مَعلولین', 'B1', 'B2'), -- disabled people (formal)
  (207454, 'گُمراهی', 'B1', 'B2'), -- being misguided / deviance (formal)
  (207455, 'تَحدید', 'B2', 'C1'), -- limitation / restriction (formal)
  (207456, 'دِلیرانه', 'B1', 'B2'), -- bravely (formal)
  (207457, 'بویه', 'B2', 'C1'), -- buoy (formal, nautical)
  (207461, 'بی‌سَواد', 'B1', 'C1'), -- illiterate (formal)
  (207462, 'گَهگاه', 'B1', 'C1'), -- occasionally (formal)
  (207463, 'واکسینه', 'B1', 'B2'), -- vaccinated (formal; واکسینه کردن = to vaccinate)
  (207464, 'شَهوَتی', 'B2', 'C1'), -- lustful (formal)
  (207465, 'هَواخوری', 'B1', 'B2'), -- outdoor stroll / prison yard time (formal)
  (207466, 'بیعَت', 'B2', 'C1'), -- allegiance / pledge (formal, political-religious)
  (207468, 'دِلپَسَند', 'B1', 'C1'), -- pleasant / likeable (formal)
  (207469, 'کَبیره', 'B2', 'C1'), -- grave / major [sin] (formal, religious)
  (207470, 'پُف', 'B1', 'B2'), -- puff / fluff (formal)
  (207471, 'سَرآخِر', 'B1', 'C1'), -- in the end / finally (formal)
  (207472, 'بَرخاسته', 'B1', 'C1'), -- risen / arisen (formal)
  (207474, 'مَعدوم', 'B2', 'C1'), -- executed [put to death] / extinct (formal)
  (207475, 'یاوَر', 'B1', 'B2'), -- helper / assistant (formal, literary)
  (207476, 'کوهان', 'B1', 'C1'), -- hump [camel] (formal)
  (207477, 'خَشنودی', 'B1', 'B2'), -- satisfaction / being pleased (formal, literary)
  (207478, 'تَفاسیر', 'B1', 'B2'), -- interpretations / exegeses (formal, plural of تفسیر)
  (207479, 'ماوَرایی', 'B1', 'B2'), -- supernatural / otherworldly (formal)
  (207480, 'تَبَهکاری', 'B1', 'B2'), -- criminality / villainy (formal)
  (207481, 'کُلُنی', 'B1', 'B2'), -- colony [biological] (loanword)
  (207482, 'این‌جانِب', 'B2', 'C1'), -- the undersigned / I (formal)
  (207483, 'سَرپایی', 'B1', 'B2'), -- outpatient / walk-in [medical] (formal)
  (207484, 'گلوکز', 'B1', 'C1'), -- glucose (loanword)
  (207485, 'فروتنانه', 'B2', 'C1'), -- humbly (formal)
  (207486, 'دونَفَره', 'B1', 'B2'), -- for two people (formal)
  (207487, 'نَحیف', 'B2', 'C1'), -- frail / emaciated (formal)
  (207488, 'گِشنیز', 'A1', 'A2'), -- coriander
  (207489, 'دُزدگیر', 'A2', 'B1'), -- alarm system / anti-theft device
  (207490, 'نِگاره', 'B2', 'C1'), -- image / artwork (formal, literary)
  (207491, 'مَوروثی', 'B1', 'B2'), -- hereditary (formal)
  (207492, 'اِقتِباس', 'B1', 'C1'), -- adaptation [film/literary] (formal)
  (207493, 'گَزاف', 'B2', 'C1'), -- exorbitant / exaggerated (formal)
  (207495, 'بَرافروخته', 'B2', 'C1'), -- enraged / inflamed (formal)
  (207496, 'سانتیگراد', 'B1', 'B2'), -- Celsius / centigrade (loanword)
  (207497, 'نیرومَندی', 'B1', 'B2'), -- strength / power (formal)
  (207498, 'پِژوهِشی', 'B1', 'B2'), -- research-related (formal)
  (207499, 'بَکسِل', 'B1', 'B2'), -- tow cable / towing (formal, loanword)
  (207500, 'جِن‌گیر', 'B2', 'C1'), -- exorcist (formal)
  (207501, 'اَساطیر', 'B1', 'B2'), -- myths / legends (formal, plural)
  (207502, 'بَدتَرکیب', 'B2', 'C1'), -- unshapely / ill-formed (formal)
  (207503, 'اِسانس', 'B1', 'C1'), -- essence / extract [flavoring] (loanword)
  (207504, 'حُجله', 'B2', 'C1'), -- bridal chamber (formal)
  (207505, 'تَأَثُّر', 'B2', 'C1'), -- sorrow / grief (formal)
  (207506, 'بَرفَک', 'B1', 'C1'), -- snow static; thrush [medical] (formal)
  (207507, 'کُتلِت', 'A2', 'B1'), -- cutlet [food] (loanword)
  (207508, 'مَنجَنیق', 'B2', 'C1'), -- catapult / trebuchet (formal)
  (207510, 'تیرَرَس', 'B1', 'B2'), -- range [of fire] (formal)
  (207511, 'مُفتَضِحانه', 'B2', 'C1'), -- disgracefully (formal)
  (207512, 'پَذیرا', 'B1', 'B2'), -- welcoming / receptive (formal)
  (207513, 'هَدفمَند', 'B1', 'C1'), -- purposeful / targeted (formal)
  (207515, 'مُلایَمَت', 'B1', 'B2'), -- gentleness / mildness (formal)
  (207516, 'باروَری', 'B1', 'B2'), -- fertility (formal)
  (207517, 'کیوی', 'A2', 'B1'), -- kiwi [fruit/bird]
  (207518, 'کوه‌نَوَرد', 'B1', 'C1'), -- mountaineer (formal)
  (207519, 'مُنعَقِد', 'B2', 'C1'), -- concluded / convened [formal, e.g. treaty]
  (207520, 'لَبَنیّات', 'A2', 'B1'), -- dairy products
  (207521, 'تَزئینی', 'B1', 'B2'), -- decorative (formal)
  (207522, 'اَزواج', 'B2', 'C1'), -- spouses (formal, plural)
  (207523, 'پیشاهَنگی', 'B1', 'B2'), -- scouting [boy/girl scouts] (formal)
  (207524, 'اُرکیده', 'A2', 'B1'), -- orchid
  (207525, 'تَبعیضی', 'B1', 'C1'), -- discriminatory (formal)
  (207526, 'بُراده', 'B1', 'C1'), -- filing / shaving [metal] (formal)
  (207527, 'مُنقَضی', 'B1', 'B2'), -- expired (formal)
  (207528, 'میخانه', 'B1', 'B2'), -- tavern / bar (formal, literary)
  (207529, 'یَل', 'B2', 'C1'), -- hero / champion (formal, literary/epic)
  (207530, 'تیربار', 'B1', 'B2'), -- machine gun (formal)
  (207531, 'مُساعده', 'B1', 'C1'), -- salary advance (formal)
  (207532, 'مُلاحَظات', 'B1', 'C1'), -- considerations (formal)
  (207533, 'جوینده', 'B1', 'B2'), -- seeker (formal)
  (207534, 'بالاشَهر', 'B1', 'C1'), -- uptown / affluent part of city (formal)
  (207536, 'ریاضی‌دان', 'B1', 'B2'), -- mathematician (formal)
  (207537, 'سیما', 'B2', 'C1'), -- face / appearance (formal, literary)
  (207538, 'زینَت', 'B1', 'C1'), -- adornment / decoration (formal)
  (207539, 'خِلافکاری', 'B1', 'B2'), -- criminal activity / wrongdoing (formal)
  (207540, 'فُروغ', 'B2', 'C1'), -- radiance / splendor (formal, literary)
  (207541, 'نِئون', 'A2', 'B1'), -- neon (loanword)
  (207542, 'بَلعیدَن', 'B1', 'B2'), -- to swallow / to devour
  (207543, 'سوگُلی', 'B2', 'C1'), -- favorite [esp. concubine/favorite child] (formal)
  (207544, 'پُربار', 'B1', 'B2'), -- fruitful / productive (formal)
  (207545, 'لوچ', 'B1', 'C1'), -- cross-eyed (formal)
  (207546, 'آبِستَن', 'B2', 'C1'), -- pregnant [animal; also figurative] (formal)
  (207547, 'اُرگانیک', 'A2', 'B1'), -- organic (loanword)
  (207549, 'مَعبود', 'B2', 'C1'), -- deity / object of worship (formal)
  (207550, 'عَلیل', 'B2', 'C1'), -- sick / disabled / infirm (formal)
  (207551, 'موتورسواری', 'A2', 'B1'), -- motorcycling
  (207552, 'وَفات', 'B1', 'C1'), -- death / passing (formal)
  (207553, 'حُزن', 'B2', 'C1'), -- sorrow / grief (formal, literary)
  (207554, 'غُربَت', 'B1', 'C1'), -- exile / being a stranger [in a foreign land] (formal)
  (207555, 'اَنیمه', 'A2', 'B1'), -- anime (loanword)
  (207556, 'کورس', 'B1', 'C1'), -- course / race [sports] (loanword)
  (207557, 'طَبخ', 'B1', 'C1'), -- cooking (formal)
  (207558, 'وازِلین', 'B1', 'C1'), -- Vaseline / petroleum jelly (loanword)
  (207559, 'چوپانی', 'B1', 'C1'), -- shepherding (formal)
  (207560, 'مَلامَت', 'B2', 'C1'), -- reproach / blame (formal)
  (207561, 'ماجراجویانه', 'B2', 'C1'), -- adventurously (formal)
  (207562, 'تَقلیل', 'B1', 'B2'), -- reduction / decrease (formal)
  (207563, 'دَعوی', 'B2', 'C1'), -- lawsuit / claim (formal, legal)
  (207564, 'عَنبیه', 'B2', 'C1'), -- iris [eye] (medical)
  (207565, 'زورگویی', 'B1', 'B2'), -- bullying (formal)
  (207566, 'پاسداری', 'B1', 'C1'), -- guarding / safeguarding (formal)
  (207567, 'دوگانگی', 'B1', 'B2'), -- duality (formal)
  (207568, 'یَخ‌زَده', 'A2', 'B1'), -- frozen
  (207569, 'کِمرو', 'B1', 'C1'), -- shy / timid (formal)
  (207570, 'رَهگیری', 'B1', 'B2'), -- tracking / interception (formal)
  (207571, 'ناوبَری', 'B1', 'B2'), -- navigation (formal)
  (207572, 'حَصر', 'B2', 'C1'), -- confinement / siege (formal; حصر خانگی = house arrest)
  (207573, 'زودهَنگام', 'B1', 'C1'), -- premature / early (formal)
  (207574, 'هَلاکَت', 'B2', 'C1'), -- death / destruction (formal)
  (207575, 'جایِز', 'B1', 'B2'), -- permissible / lawful (formal)
  (207577, 'کوانتوم', 'B1', 'B2'), -- quantum (loanword)
  (207578, 'فتوکپی', 'A2', 'B1'), -- photocopy
  (207579, 'ثانیاً', 'B1', 'B2'), -- secondly (formal)
  (207580, 'تَعالی', 'B2', 'C1'), -- transcendence / exaltation (formal)
  (207581, 'فَجایِع', 'B1', 'B2'), -- disasters / tragedies (formal, plural of فاجعه)
  (207582, 'مُتَمادی', 'B2', 'C1'), -- prolonged / continuous (formal; سالیان متمادی)
  (207583, 'سَفیه', 'B2', 'C1'), -- foolish / imprudent (formal, also legal term)
  (207584, 'نِقرِس', 'B2', 'C1'), -- gout (medical)
  (207585, 'فَهیم', 'B2', 'C1'), -- understanding / perceptive (formal)
  (207586, 'مُروری', 'B1', 'C1'), -- review-related / cursory (formal)
  (207587, 'بیزاری', 'B1', 'B2'), -- aversion / disgust (formal)
  (207588, 'نیروبَخش', 'B1', 'C1'), -- energizing / invigorating (formal)
  (207589, 'یِکجور', 'B1', 'B2'), -- somehow / of one kind (formal)
  (207590, 'مَشیَّت', 'C1', 'C2'), -- divine will (formal, religious, rare)
  (207591, 'ماتادور', 'B1', 'C1'), -- matador (loanword)
  (207592, 'قاعِدگی', 'B2', 'C1'), -- menstruation (medical)
  (207593, 'سَربازخانه', 'B1', 'C1'), -- barracks (formal)
  (207594, 'اَطوار', 'B2', 'C1'), -- manners / airs (formal, plural)
  (207595, 'وَحشیگَری', 'B1', 'B2'), -- savagery / brutality (formal)
  (207597, 'شِگَرف', 'B2', 'C1'), -- extraordinary / amazing (formal, literary)
  (207598, 'روانپِزِشکی', 'B1', 'B2'), -- psychiatry
  (207599, 'خُداوَندی', 'B2', 'C1'), -- divinity / lordship (formal)
  (207600, 'مارکیز', 'B2', 'C1'), -- marquis (loanword, title)
  (207601, 'بَندبازی', 'B1', 'C1'), -- tightrope walking (formal)
  (207602, 'نُحسی', 'B2', 'C1'), -- ill-omened nature / inauspiciousness (formal)
  (207603, 'جَبَل', 'C1', 'C2'), -- mountain (formal, literary, rare)
  (207604, 'یِک‌طَرَفه', 'A2', 'B1'), -- one-way
  (207605, 'روحانیون', 'B1', 'B2'), -- clergy (formal, plural)
  (207606, 'ناهَماهَنگی', 'B1', 'C1'), -- lack of coordination (formal)
  (207607, 'نِگاتیو', 'B1', 'B2'), -- negative [film] (loanword)
  (207608, 'دیار', 'B2', 'C1'), -- land / homeland (formal, literary)
  (207609, 'هِدست', 'A2', 'B1'), -- headset (loanword)
  (207610, 'شیوَن', 'B2', 'C1'), -- wailing / lamentation (formal)
  (207611, 'حَصبه', 'B2', 'C1'), -- typhoid fever (medical)
  (207612, 'گُل‌فروشی', 'A2', 'B1'), -- florist shop
  (207613, 'تَنومَند', 'B1', 'C1'), -- sturdy / robust (formal)
  (207614, 'عَدَس', 'A1', 'A2'), -- lentil
  (207615, 'تَبریکات', 'B1', 'B2'), -- congratulations (formal, plural)
  (207616, 'صَبورانه', 'B1', 'C1'), -- patiently (formal)
  (207617, 'آدمیزاد', 'B1', 'B2'), -- human being / mankind (formal)
  (207618, 'کَجی', 'B1', 'C1'), -- crookedness (formal)
  (207619, 'بِهداری', 'B1', 'B2'), -- infirmary / health center (formal)
  (207620, 'غَصب', 'B2', 'C1'), -- usurpation (formal, legal)
  (207621, 'هاضِمه', 'B1', 'C1'), -- digestive [system] (formal; دستگاه هاضمه)
  (207622, 'اِشغالگَر', 'B1', 'C1'), -- occupier [military] (formal)
  (207623, 'دُز', 'B1', 'B2'), -- dose (loanword)
  (207625, 'سَرسَرا', 'B1', 'C1'), -- lobby / hall (formal)
  (207626, 'مُحَصِّل', 'B1', 'C1'), -- student / pupil (formal)
  (207628, 'هَرَمی', 'B1', 'B2'), -- pyramidal (formal)
  (207629, 'اَصالَتاً', 'B1', 'B2'), -- originally / by origin (formal)
  (207630, 'اِلِکترومغناطیس', 'B2', 'C1'), -- electromagnetism
  (207631, 'نازُکی', 'B1', 'B2'), -- thinness (formal)
  (207632, 'توصیفات', 'B1', 'B2'), -- descriptions (formal, plural)
  (207633, 'بیوگرافی', 'A2', 'B1'), -- biography (loanword)
  (207634, 'رَهگُذَر', 'B1', 'C1'), -- passerby (formal)
  (207635, 'آدم‌رُبایی', 'B1', 'B2'), -- kidnapping (formal)
  (207636, 'چَپی', 'B2', 'C1'), -- leftist (formal, political)
  (207637, 'آیندِگان', 'B2', 'C1'), -- future generations (formal)
  (207638, 'حَشیش', 'B1', 'B2'), -- hashish (formal)
  (207639, 'اِنحِلال', 'B1', 'C1'), -- dissolution (formal, organization)
  (207640, 'بَرفَراز', 'B2', 'C1'), -- above / over (formal, literary)
  (207641, 'شَبانگاه', 'B2', 'C1'), -- evening time (formal, literary)
  (207642, 'زندگی‌نامه', 'B1', 'C1'), -- biography (formal)
  (207643, 'چگالی', 'B1', 'B2'), -- density [physics] (formal)
  (207645, 'زَگیل', 'B1', 'B2'), -- wart (formal)
  (207646, 'خَبَرگُزاری', 'B1', 'B2'), -- news agency (formal)
  (207647, 'زَنجَبیلی', 'B1', 'B2'), -- ginger-colored / gingery (formal)
  (207648, 'خِردمَندی', 'B1', 'B2'), -- wisdom (formal)
  (207649, 'اِمتیازات', 'B1', 'B2'), -- privileges / scores (formal, plural)
  (207650, 'کِشتزار', 'B1', 'C1'), -- farmland / cropland (formal)
  (207652, 'اِلزاماً', 'B1', 'B2'), -- necessarily (formal)
  (207653, 'تُجّار', 'B1', 'C1'), -- merchants (formal, plural of تاجر)
  (207654, 'قَویاً', 'B1', 'B2'), -- strongly (formal)
  (207655, 'غارَتگَری', 'B1', 'C1'), -- plundering / pillaging (formal)
  (207656, 'عَیناً', 'B1', 'B2'), -- exactly / precisely (formal)
  (207657, 'مَحسوس', 'B1', 'C1'), -- tangible / perceptible (formal)
  (207658, 'تِرومبون', 'B1', 'C1'), -- trombone (loanword)
  (207659, 'دِلبَری', 'B1', 'B2'), -- charm / allure / flirtation (formal)
  (207660, 'شَقی', 'B2', 'C1'), -- wicked / depraved (formal, literary)
  (207661, 'حوریه', 'B2', 'C1'), -- houri [heavenly maiden] (formal, religious)
  (207662, 'بَرخاستَن', 'B1', 'B2'), -- to rise / to stand up
  (207663, 'دَرَخشِندگی', 'B1', 'B2'), -- brilliance / radiance (formal)
  (207664, 'پُرطَرفدار', 'B1', 'C1'), -- popular / well-liked (formal)
  (207665, 'اَمراض', 'B1', 'C1'), -- diseases (formal, plural of مرض)
  (207666, 'مَحافِل', 'B2', 'C1'), -- circles [social] (formal, plural of محفل)
  (207667, 'مُروَّت', 'B2', 'C1'), -- chivalry / kindness (formal, literary)
  (207668, 'کَفَل', 'B2', 'C1'), -- buttock / hip (formal)
  (207669, 'بَواسیر', 'B2', 'C1'), -- hemorrhoids (medical)
  (207670, 'فَرمانبَرداری', 'B1', 'B2'), -- obedience (formal)
  (207671, 'حَواریون', 'B2', 'C1'), -- apostles (formal, religious)
  (207672, 'عِلَل', 'B1', 'C1'), -- causes (formal, plural of علت)
  (207674, 'آمبولی', 'B2', 'C1'), -- embolism (medical)
  (207675, 'دوپامین', 'B1', 'B2'), -- dopamine (loanword)
  (207676, 'خیالات', 'B1', 'B2'), -- fancies / delusions (formal, plural)
  (207677, 'آخور', 'B1', 'C1'), -- manger / stable trough (formal)
  (207678, 'مُناقَشه', 'B1', 'C1'), -- dispute / controversy (formal)
  (207679, 'اِمدادی', 'B1', 'C1'), -- rescue-related (formal)
  (207680, 'تُلُمبه', 'B1', 'B2'), -- pump (formal)
  (207681, 'خَبَرنامه', 'B1', 'B2'), -- newsletter (formal)
  (207682, 'مَشهود', 'B1', 'C1'), -- evident / obvious (formal)
  (207683, 'چَمباتَمه', 'B2', 'C1'), -- squatting (formal; چمباتمه زدن)
  (207684, 'دِلشِکَسته', 'B1', 'C1'), -- heartbroken (formal)
  (207685, 'لَشکَرکِشی', 'B2', 'C1'), -- military campaign (formal)
  (207686, 'بی‌شَرَف', 'B2', 'C1'), -- dishonorable / scoundrel (formal)
  (207687, 'کیمیاگَر', 'B2', 'C1'), -- alchemist (formal)
  (207688, 'فَتیله', 'B1', 'B2'), -- wick (formal)
  (207689, 'آلِرژیک', 'A2', 'B1'), -- allergic (loanword)
  (207691, 'پیشامَد', 'B1', 'B2'), -- occurrence / event (formal)
  (207692, 'شیرفَهم', 'B1', 'B2'), -- understood (formal; شیرفهم شدن = to get it)
  (207693, 'شُمارِشگَر', 'B1', 'C1'), -- counter [device] (formal)
  (207694, 'وارداتی', 'B1', 'B2'), -- imported (formal)
  (207695, 'نامُتِعادِل', 'B1', 'C1'), -- unbalanced (formal)
  (207696, 'دُردونه', 'B1', 'B2'), -- darling / pet [affectionate term] (formal)
  (207697, 'بُنیه', 'B2', 'C1'), -- physical strength / constitution (formal)
  (207698, 'اِبطال', 'B2', 'C1'), -- annulment / invalidation (formal, legal)
  (207699, 'صادِره', 'B2', 'C1'), -- issued (formal; صادره از)
  (207700, 'واشِر', 'B1', 'C1'), -- washer [hardware] (loanword)
  (207701, 'اِحتیاجات', 'B1', 'B2'), -- needs (formal, plural)
  (207702, 'شَهوانی', 'B2', 'C1'), -- sensual / lustful (formal)
  (207703, 'شِفابَخش', 'B2', 'C1'), -- healing / curative (formal)
  (207704, 'کُنتور', 'B1', 'C1'), -- meter [utility] (loanword)
  (207705, 'هَریک', 'B1', 'B2'), -- each one (formal)
  (207706, 'خازِن', 'B2', 'C1'), -- capacitor [electronics] (formal)
  (207707, 'شَنیع', 'B2', 'C1'), -- heinous / atrocious (formal)
  (207708, 'شَبدَر', 'A2', 'B1'), -- clover
  (207709, 'آرژانتینی', 'A2', 'B1'), -- Argentine (nationality)
  (207710, 'آفتابگَردان', 'A1', 'A2'), -- sunflower
  (207711, 'فروشَندگی', 'B1', 'C1'), -- salesmanship (formal)
  (207712, 'مَنافِذ', 'B2', 'C1'), -- pores (formal, plural of منفذ)
  (207713, 'شاهَنشاه', 'B2', 'C1'), -- emperor / king of kings (formal)
  (207714, 'سَرنِگونی', 'B1', 'B2'), -- overthrow [political] (formal)
  (207716, 'پیشکار', 'B2', 'C1'), -- steward / agent (formal, historical)
  (207717, 'فِشُردگی', 'B1', 'C1'), -- compactness / density (formal)
  (207718, 'بازجو', 'B1', 'C1'), -- interrogator (formal)
  (207719, 'وِرد', 'B2', 'C1'), -- incantation / chant (formal)
  (207720, 'آبکَش', 'A2', 'B1'), -- colander / strainer
  (207721, 'یَمَنی', 'A2', 'B1'), -- Yemeni (nationality)
  (207722, 'بُهتان', 'B2', 'C1'), -- slander / false accusation (formal)
  (207723, 'هَلهَله', 'B2', 'C1'), -- cheering / ululation (formal)
  (207724, 'خورَنده', 'B1', 'C1'), -- corrosive (formal)
  (207725, 'دُشنام', 'B1', 'C1'), -- insult / curse (formal)
  (207726, 'قایِقران', 'B1', 'C1'), -- boatman / rower (formal)
  (207727, 'وِزارَتخانه', 'B1', 'C1'), -- ministry [government] (formal)
  (207728, 'تَعارُض', 'B1', 'C1'), -- conflict / contradiction (formal)
  (207729, 'نورپَردازی', 'B1', 'B2'), -- lighting [design] (formal)
  (207730, 'مُتَصَوَّر', 'B2', 'C1'), -- imaginable / conceivable (formal)
  (207731, 'جوشِش', 'B1', 'C1'), -- boiling / eruption (formal)
  (207732, 'چِریکی', 'B2', 'C1'), -- guerrilla (formal)
  (207733, 'کلینیکی', 'B1', 'C1'), -- clinical (formal)
  (207734, 'دارکوب', 'A2', 'B1'), -- woodpecker
  (207735, 'بازگُشایی', 'B1', 'B2'), -- reopening (formal)
  (207736, 'بارِقه', 'B2', 'C1'), -- spark / glimmer (formal, literary)
  (207737, 'وِلگَردی', 'B1', 'B2'), -- vagrancy / loitering (formal)
  (207738, 'بارکُد', 'A2', 'B1'), -- barcode (loanword)
  (207739, 'اُمیدبَخش', 'B1', 'B2'), -- hope-giving / encouraging (formal)
  (207740, 'لوزه', 'B1', 'C1'), -- tonsil (medical)
  (207741, 'قِی', 'B1', 'C1'), -- vomit (formal)
  (207742, 'تَخمینی', 'B1', 'C1'), -- estimated / approximate (formal)
  (207743, 'اِنتِقادی', 'B1', 'C1'), -- critical (formal)
  (207744, 'بِتُنی', 'B1', 'B2'), -- concrete [adjective] (formal)
  (207745, 'خَمیردَندان', 'A1', 'A2'), -- toothpaste
  (207746, 'اِنتِقامجو', 'B1', 'C1'), -- vengeful / avenger (formal)
  (207747, 'تَرکیبات', 'B1', 'B2'), -- compounds / combinations (formal)
  (207748, 'رَنگدانه', 'B1', 'C1'), -- pigment (formal)
  (207749, 'ناآشنا', 'B1', 'C1'), -- unfamiliar (formal)
  (207750, 'مُکاشِفات', 'B2', 'C1'), -- revelations (formal, plural)
  (207751, 'ریاکارانه', 'B2', 'C1'), -- hypocritically (formal)
  (207752, 'بُغض', 'B1', 'C1'), -- lump in throat [from crying] (formal)
  (207753, 'تَعَهُّدنامه', 'B1', 'C1'), -- written pledge / commitment letter (formal)
  (207755, 'شِکایات', 'B1', 'B2'), -- complaints (formal, plural)
  (207757, 'مُشرِف', 'B2', 'C1'), -- overlooking (formal)
  (207758, 'فوک', 'A2', 'B1'), -- seal [animal]
  (207759, 'داوطَلَبی', 'B1', 'C1'), -- volunteering (formal)
  (207760, 'تَباهی', 'B1', 'B2'), -- corruption / ruin (formal)
  (207761, 'سَنجه', 'B2', 'C1'), -- criterion / measure (formal)
  (207762, 'واناديوم', 'B2', 'C1'), -- vanadium (loanword, chemistry)
  (207764, 'کاردَستی', 'A2', 'B1'), -- handicraft
  (207765, 'شُکرگُزار', 'B1', 'C1'), -- grateful / thankful (formal)
  (207766, 'خورشیدگِرِفتِگی', 'B1', 'C1'), -- solar eclipse (formal)
  (207767, 'دَستورپَخت', 'A2', 'B1'), -- recipe
  (207768, 'فَقید', 'B2', 'C1'), -- the late [deceased] (formal)
  (207769, 'تَقطیر', 'B2', 'C1'), -- distillation (formal)
  (207770, 'دِلیری', 'B1', 'B2'), -- bravery / valor (formal)
  (207771, 'چیدمان', 'B1', 'B2'), -- arrangement / layout (formal)
  (207772, 'فَلس', 'B1', 'C1'), -- scale [fish/reptile] (formal)
  (207773, 'اِفِکت', 'B1', 'C1'), -- effect [sound/visual] (loanword)
  (207774, 'آمِر', 'B2', 'C1'), -- commander / one who orders (formal, legal)
  (207775, 'تَدارُکاتی', 'B1', 'B2'), -- logistical (formal)
  (207776, 'سَرخَط', 'B1', 'C1'), -- headline (formal)
  (207777, 'بُلَندپَروازانه', 'B2', 'C1'), -- ambitiously (formal)
  (207778, 'خودآگاهی', 'B1', 'B2'), -- self-awareness / consciousness (formal)
  (207779, 'شاکِر', 'B2', 'C1'), -- grateful (formal)
  (207780, 'صُبحگاهی', 'B1', 'B2'), -- morning [adjective] (formal)
  (207781, 'بیکینی', 'A2', 'B1'), -- bikini (loanword)
  (207782, 'بَنادِر', 'B1', 'C1'), -- ports (formal, plural of بندر)
  (207783, 'پیگیر', 'B1', 'B2'), -- following up / persistent (formal)
  (207784, 'اَسبَق', 'B2', 'C1'), -- former / preceding (formal)
  (207785, 'پِنالتی', 'A2', 'B1'), -- penalty [sports] (loanword)
  (207787, 'مُستَثنی', 'B2', 'C1'), -- excepted / exempted (formal)
  (207788, 'هِلالی', 'B2', 'C1'), -- crescent-shaped (formal)
  (207789, 'مَعذِرَت‌خواهی', 'B1', 'B2'), -- apology (formal)
  (207790, 'ایلات', 'B2', 'C1'), -- tribes (formal, plural of ایل)
  (207791, 'نیکِل', 'B1', 'B2'), -- nickel [metal] (loanword)
  (207792, 'بی‌باک', 'B1', 'C1'), -- fearless (formal)
  (207793, 'آنفلوانزا', 'B1', 'C1'), -- influenza (loanword)
  (207794, 'اَراجیف', 'B2', 'C1'), -- nonsense / gibberish (formal, plural)
  (207795, 'واهی', 'B2', 'C1'), -- unfounded / baseless (formal)
  (207796, 'شوری', 'B1', 'B2'), -- saltiness (formal)
  (207797, 'لیف', 'A2', 'B1'), -- loofah / bath sponge
  (207798, 'فَرمانرَوایی', 'B2', 'C1'), -- sovereignty / reign (formal)
  (207799, 'صوری', 'B1', 'B2'), -- formal / nominal (formal)
  (207800, 'عاقِد', 'B2', 'C1'), -- officiant [marriage] (formal)
  (207801, 'مورمور', 'B1', 'C1'), -- goosebumps feeling / shiver (formal; مورمور شدن)
  (207802, 'کِشیدگی', 'B1', 'C1'), -- strain / tension (formal)
  (207803, 'بازدِهی', 'B1', 'B2'), -- efficiency / yield (formal)
  (207804, 'مُهرومُوم', 'B2', 'C1'), -- seal / sealing (formal)
  (207805, 'غیرواقِعی', 'B1', 'B2'), -- unrealistic (formal)
  (207806, 'نامُقَدَّس', 'B2', 'C1'), -- unholy (formal)
  (207807, 'نَبی', 'B2', 'C1'), -- prophet (formal, religious)
  (207808, 'عَمیقاً', 'B1', 'B2'), -- deeply (formal)
  (207809, 'اَجزا', 'B1', 'C1'), -- components / parts (formal, plural of جزء)
  (207810, 'گرافیک', 'A2', 'B1'), -- graphics (loanword)
  (207811, 'تَفریحگاه', 'B1', 'B2'), -- recreation area / resort (formal)
  (207812, 'بیگاری', 'B2', 'C1'), -- forced labor (formal)
  (207813, 'روان‌گَردان', 'B2', 'C1'), -- psychoactive / hallucinogenic (formal)
  (207814, 'تَکانه', 'B2', 'C1'), -- impulse [physics/psychology] (formal)
  (207815, 'فَرضی', 'B1', 'B2'), -- hypothetical (formal)
  (207816, 'غُضروف', 'B2', 'C1'), -- cartilage (medical)
  (207817, 'مُخاطَبان', 'B1', 'C1'), -- audience / addressees (formal)
  (207818, 'جُثّه', 'B1', 'C1'), -- body / build [physical size] (formal)
  (207819, 'بااین‌که', 'B1', 'B2'), -- although (formal)
  (207820, 'کارگُزینی', 'B2', 'C1'), -- personnel affairs [office] (formal)
  (207821, 'نَخودفَرَنگی', 'A1', 'A2'), -- pea
  (207822, 'وَرای', 'B2', 'C1'), -- beyond (formal)
  (207823, 'آنتروپی', 'C1', 'C2'), -- entropy [physics] (formal, rare)
  (207824, 'کَمابیش', 'B1', 'C1'), -- more or less (formal)
  (207825, 'مُطالِعاتی', 'B1', 'B2'), -- study-related (formal)
  (207826, 'سَرکوفت', 'B2', 'C1'), -- reproach / rebuke (formal)
  (207827, 'رِقابَتی', 'B1', 'B2'), -- competitive (formal)
  (207829, 'هیاهو', 'B1', 'B2'), -- clamor / uproar (formal)
  (207830, 'هوابَند', 'B1', 'C1'), -- airtight (formal)
  (207831, 'ییلاق', 'B2', 'C1'), -- summer resort / highland pasture (formal)
  (207832, 'وَزیدَن', 'B1', 'B2'), -- to blow [wind]
  (207833, 'تُندباد', 'B1', 'C1'), -- gale / strong wind (formal)
  (207834, 'اِفشاگَری', 'B1', 'B2'), -- exposure / whistleblowing (formal)
  (207835, 'فَرسَنگ', 'B2', 'C1'), -- farsakh [old unit of distance] (formal)
  (207836, 'بیراه', 'B2', 'C1'), -- off-track / wrong path (formal)
  (207837, 'مَسیریابی', 'B1', 'B2'), -- route-finding / navigation (formal)
  (207838, 'ناچاری', 'B1', 'B2'), -- helplessness / being forced (formal)
  (207839, 'دِلباز', 'B2', 'C1'), -- generous / openhearted (formal)
  (207840, 'زیرِشیروانی', 'B1', 'C1'), -- attic (formal)
  (207841, 'اَراضی', 'B1', 'C1'), -- lands / territories (formal, plural of ارض)
  (207842, 'دارچینی', 'B1', 'B2'), -- cinnamon-colored (formal)
  (207843, 'سوگ', 'B2', 'C1'), -- mourning (formal)
  (207844, 'شَهریار', 'B2', 'C1'), -- monarch / sovereign (formal, literary)
  (207845, 'آبگیر', 'B1', 'C1'), -- pond / water reservoir (formal)
  (207846, 'وُفور', 'B1', 'C1'), -- abundance (formal)
  (207847, 'جَفنگ', 'B2', 'C1'), -- nonsense (formal)
  (207849, 'حَلزونی', 'B1', 'B2'), -- spiral / snail-shaped (formal)
  (207850, 'مِنیزیم', 'B1', 'C1'), -- magnesium (loanword)
  (207851, 'تَحقیرآمیز', 'B1', 'B2'), -- humiliating / derogatory (formal)
  (207852, 'سیانید', 'B2', 'C1'), -- cyanide (loanword)
  (207854, 'نازپَرورده', 'B1', 'C1'), -- pampered / spoiled (formal)
  (207855, 'فُتوح', 'C1', 'C2'), -- conquests (formal, plural of فتح, rare)
  (207856, 'دادخواهی', 'B2', 'C1'), -- seeking justice (formal, legal)
  (207857, 'بِدین‌وَسیله', 'B2', 'C1'), -- hereby (formal)
  (207858, 'حَقیرانه', 'B2', 'C1'), -- abjectly / humbly (formal)
  (207859, 'مَجالِس', 'B1', 'C1'), -- assemblies / gatherings (formal, plural of مجلس)
  (207860, 'فونت', 'A2', 'B1'), -- font (loanword)
  (207863, 'شُقایِق', 'A2', 'B1'), -- poppy [flower]
  (207864, 'پُرفِشار', 'B1', 'C1'), -- high-pressure (formal)
  (207865, 'زورگو', 'B1', 'C1'), -- bully (formal)
  (207866, 'عِرفانی', 'B2', 'C1'), -- mystical (formal)
  (207867, 'کیهانی', 'B2', 'C1'), -- cosmic (formal)
  (207868, 'پوشالی', 'B2', 'C1'), -- flimsy / hollow (formal, figurative)
  (207869, 'کوپه', 'B1', 'B2'), -- compartment [train] (formal, loanword)
  (207870, 'رَسا', 'B2', 'C1'), -- eloquent / clear [voice] (formal)
  (207871, 'خُجَسته', 'B2', 'C1'), -- auspicious / blessed (formal, literary)
  (207872, 'شیردِل', 'B2', 'C1'), -- lionhearted (formal)
  (207873, 'عَدل', 'B2', 'C1'), -- justice (formal)
  (207874, 'ماهی‌خوار', 'B2', 'C1'), -- heron [fish-eating bird] (formal)
  (207875, 'مَجال', 'B1', 'C1'), -- opportunity / chance (formal)
  (207876, 'طَبیب', 'B2', 'C1'), -- physician (formal, literary)
  (207877, 'قانقاریا', 'C1', 'C2'), -- gangrene (formal, rare, medical)
  (207878, 'نافَرجام', 'B2', 'C1'), -- unsuccessful / inconclusive (formal)
  (207879, 'مایونز', 'A2', 'B1'), -- mayonnaise (loanword)
  (207880, 'اَثنا', 'B2', 'C2'), -- during / in the course of (formal; در اثنای)
  (207881, 'زَرادخانه', 'B2', 'C1'), -- arsenal (formal)
  (207884, 'صَده', 'B2', 'C1'), -- century (formal, literary)
  (207885, 'دِلخوشی', 'B1', 'B2'), -- consolation / small pleasure (formal)
  (207886, 'اِنتِقامی', 'B1', 'B2'), -- vengeful / retaliatory (formal)
  (207887, 'غالِباً', 'B1', 'B2'), -- mostly / usually (formal)
  (207888, 'مُبتِکرانه', 'B2', 'C1'), -- innovatively (formal)
  (207889, 'لَک', 'B1', 'B2'), -- stain / spot (formal)
  (207890, 'روبِه‌رو', 'B1', 'C1'), -- face to face (formal)
  (207891, 'واژگان', 'B1', 'C1'), -- vocabulary / lexicon (formal)
  (207892, 'پونه', 'B2', 'C1'), -- pennyroyal [mint herb] (formal)
  (207893, 'پِستانَک', 'A2', 'B1'), -- pacifier
  (207894, 'جِرگه', 'B2', 'C1'), -- circle / assembly (formal, tribal council)
  (207895, 'مَشرِق', 'B2', 'C1'), -- the East / Orient (formal)
  (207896, 'فوقانی', 'B2', 'C1'), -- upper (formal)
  (207897, 'قَناعَت', 'B2', 'C1'), -- contentment / frugality (formal)
  (207898, 'آبگَرم', 'A2', 'B1'), -- hot spring / hot water
  (207899, 'اَرزَنده', 'B1', 'C1'), -- valuable / worthwhile (formal)
  (207900, 'چَندگاهی', 'B2', 'C1'), -- for a while (formal, literary)
  (207901, 'پیشین', 'B1', 'B2'), -- former / previous (formal)
  (207902, 'جِهانگَرد', 'B1', 'C1'), -- world traveler / tourist (formal)
  (207903, 'گاوچَران', 'A2', 'B1'), -- cowboy
  (207904, 'روا', 'B2', 'C1'), -- permissible (formal)
  (207905, 'بی‌صِدا', 'B1', 'C1'), -- silent / soundless (formal)
  (207906, 'بَدشِکل', 'B1', 'C1'), -- misshapen / deformed (formal)
  (207907, 'وَرید', 'B2', 'C1'), -- vein (medical)
  (207908, 'کِتانی', 'B1', 'C1'), -- linen / canvas [adjective] (formal)
  (207909, 'تَفریق', 'B1', 'C1'), -- subtraction [math] (formal)
  (207910, 'خونگَرم', 'B1', 'C1'), -- warm-hearted / hospitable (formal)
  (207911, 'پاکباز', 'B2', 'C1'), -- sincere / devoted (formal, literary)
  (207913, 'دَستفُروش', 'B1', 'C1'), -- street vendor / peddler (formal)
  (207914, 'ناجَوانمَردانه', 'B2', 'C1'), -- unfairly / dishonorably (formal)
  (207915, 'گالاکسی', 'A2', 'B1'), -- galaxy (loanword)
  (207916, 'خَراشیدگی', 'B1', 'C1'), -- scratch / abrasion (formal)
  (207917, 'مَنظوم', 'B2', 'C1'), -- versified / in verse (formal)
  (207918, 'قَلیایی', 'B2', 'C1'), -- alkaline [chemistry] (formal)
  (207919, 'تَفت', 'B2', 'C1'), -- heat / scorching (formal; تفت دادن = to sauté)
  (207920, 'پایبَندی', 'B1', 'B2'), -- commitment / adherence (formal)
  (207921, 'بیچارگی', 'B1', 'B2'), -- helplessness / misery (formal)
  (207922, 'سِرِشت', 'B2', 'C1'), -- nature / disposition (formal)
  (207923, 'فائِق', 'B2', 'C1'), -- prevailing / overcoming (formal; فائق آمدن)
  (207924, 'هیدروژِنی', 'B1', 'B2'), -- hydrogen [adjective] (formal)
  (207925, 'هیچ‌جا', 'A2', 'B1'), -- nowhere
  (207926, 'گازگِرِفتِگی', 'B2', 'C1'), -- frostbite (formal)
  (207927, 'مُتَلاطِم', 'B2', 'C1'), -- turbulent / agitated (formal)
  (207928, 'بینا', 'B1', 'B2'), -- sighted / seeing (formal)
  (207929, 'اِلِکترود', 'B1', 'C1'), -- electrode (loanword)
  (207930, 'یاس', 'B1', 'B2'), -- jasmine; despair (formal, literary)
  (207932, 'خیارشور', 'A2', 'B1'), -- pickled cucumber
  (207933, 'ناگُزیر', 'B1', 'B2'), -- inevitable / compelled (formal)
  (207935, 'قانونمَند', 'B1', 'C1'), -- law-abiding / orderly (formal)
  (207936, 'رادیکال', 'B1', 'B2'), -- radical (loanword)
  (207937, 'بودار', 'B1', 'C1'), -- smelly / odorous (formal)
  (207938, 'مُتَعَلِّقات', 'B1', 'C1'), -- belongings / accessories (formal)
  (207940, 'خَشمناک', 'B1', 'C1'), -- furious / wrathful (formal)
  (207941, 'مَشروعیَّت', 'B2', 'C1'), -- legitimacy (formal)
  (207942, 'لیبرال', 'B1', 'B2'), -- liberal (loanword)
  (207943, 'رَشادَت', 'B2', 'C1'), -- bravery / valor (formal)
  (207944, 'تَحَرُّکات', 'B1', 'C1'), -- movements / activities (formal)
  (207945, 'اِستِماع', 'B2', 'C1'), -- hearing / listening (formal, legal)
  (207946, 'یائِسگی', 'B2', 'C1'), -- menopause (medical)
  (207947, 'مُستَأصِل', 'B2', 'C1'), -- desperate / at wit’s end (formal)
  (207948, 'مُنفَعِل', 'B2', 'C1'), -- passive (formal)
  (207949, 'تَدهین', 'C1', 'C2'), -- anointing (formal, religious, rare)
  (207950, 'خادِمان', 'B2', 'C1'), -- servants (formal, plural of خادم)
  (207951, 'شَمشیربازی', 'B1', 'C1'), -- fencing [sport] (formal)
  (207952, 'اینان', 'B2', 'C1'), -- these [people] (formal, literary)
  (207953, 'خَصیصه', 'B2', 'C1'), -- characteristic / trait (formal)
  (207954, 'پاریسی', 'A2', 'B1'), -- Parisian
  (207955, 'سَرآغاز', 'B1', 'C1'), -- beginning / prelude (formal)
  (207956, 'عَجین', 'B2', 'C1'), -- intertwined / mixed (formal; عجین شدن)
  (207957, 'سَرشانه', 'B1', 'C1'), -- shoulder (formal)
  (207958, 'نوپا', 'B2', 'C1'), -- budding / nascent (formal, e.g. a startup)
  (207959, 'جَوانمَردی', 'B2', 'C1'), -- chivalry / nobility (formal)
  (207960, 'تاکسی‌رانی', 'B1', 'C1'), -- taxi service (formal)
  (207961, 'شیهه', 'B2', 'C1'), -- neigh [horse sound] (formal)
  (207962, 'عَضَلانی', 'B1', 'B2'), -- muscular (formal)
  (207963, 'مُبتِکِر', 'B1', 'C1'), -- innovator (formal)
  (207964, 'پودِل', 'A2', 'B1'), -- poodle (loanword)
  (207965, 'اَفزون', 'B2', 'C1'), -- increased / more (formal; افزون بر)
  (207966, 'یورتمه', 'B2', 'C1'), -- trot [horse gait] (formal)
  (207967, 'نِوید', 'B2', 'C1'), -- good news / glad tidings (formal, literary)
  (207968, 'زَبده', 'B2', 'C1'), -- expert / adept (formal)
  (207969, 'رومیان', 'B2', 'C1'), -- Romans (formal, plural)
  (207970, 'نابَرابَری', 'B1', 'B2'), -- inequality (formal)
  (207971, 'ماوَرالطَّبیعه', 'B2', 'C1'), -- supernatural / metaphysics (formal)
  (207973, 'کاپوچینو', 'A2', 'B1'), -- cappuccino (loanword)
  (207974, 'خُشکیده', 'B1', 'C1'), -- dried up / withered (formal)
  (207975, 'مُفتی', 'B2', 'C1'), -- mufti [Islamic scholar] (formal, religious)
  (207976, 'عیادَت', 'B1', 'C1'), -- visiting [the sick] (formal)
  (207977, 'دِگَردیسی', 'B2', 'C1'), -- metamorphosis (formal)
  (207978, 'سُرخَک', 'B1', 'C1'), -- measles (medical)
  (207979, 'حُلول', 'B2', 'C1'), -- arrival / onset (formal; حلول سال نو)
  (207980, 'مادّیات', 'B2', 'C1'), -- material things (formal)
  (207981, 'کاروانسَرا', 'B1', 'C1'), -- caravanserai (formal)
  (207982, 'ششُمین', 'A2', 'B1'), -- sixth [ordinal]
  (207983, 'لاتینی', 'B1', 'B2'), -- Latin (formal)
  (207984, 'مَخمَلی', 'B2', 'C1'), -- velvety (formal)
  (207985, 'جانشینی', 'B1', 'B2'), -- succession (formal)
  (207986, 'اِشغالی', 'B1', 'B2'), -- occupied (formal)
  (207987, 'میراثی', 'B2', 'C1'), -- hereditary / inherited (formal)
  (207988, 'فَرمودَن', 'B2', 'C1'), -- to command / to say (formal, honorific)
  (207989, 'صَیّاد', 'B2', 'C1'), -- hunter (formal, literary)
  (207990, 'عَلَناً', 'B1', 'B2'), -- openly / publicly (formal)
  (207991, 'آتی', 'B2', 'C1'), -- coming / future (formal)
  (207992, 'اِسلاید', 'B1', 'B2'), -- slide [presentation] (loanword)
  (207993, 'بازیگوش', 'B1', 'C1'), -- playful / mischievous (formal)
  (207994, 'نَنو', 'B1', 'C1'), -- hammock / cradle (formal)
  (207995, 'نافَرمان', 'B1', 'C1'), -- disobedient (formal)
  (207996, 'مُعتَمَد', 'B2', 'C1'), -- trustee / confidant (formal)
  (207997, 'شُکوهمَند', 'B2', 'C1'), -- glorious / majestic (formal)
  (207998, 'کَمانی', 'B1', 'B2'), -- bow-shaped / arched (formal)
  (207999, 'اورانگوتان', 'A2', 'B1'), -- orangutan (loanword)
  (208000, 'شِریانی', 'B2', 'C1'), -- arterial (formal)
  (208001, 'آبسه', 'B2', 'C1'), -- abscess (medical)
  (208002, 'واله', 'B2', 'C1'), -- enamored / infatuated (formal, literary)
  (208003, 'مُتَّفِقین', 'B2', 'C1'), -- the Allies (formal, historical)
  (208004, 'رُخسار', 'B2', 'C1'), -- face / countenance (formal, literary)
  (208005, 'یَحتَمَل', 'B1', 'B2'), -- probably (formal)
  (208006, 'خودبین', 'B1', 'C1'), -- self-centered / vain (formal)
  (208007, 'اَسَف', 'B2', 'C1'), -- regret / sorrow (formal)
  (208008, 'هُنَرنِمایی', 'B1', 'C1'), -- showcasing talent / performance (formal)
  (208009, 'مُخچه', 'B2', 'C1'), -- cerebellum (medical)
  (208010, 'حَرَمسَرا', 'B2', 'C1'), -- harem (formal)
  (208011, 'گودی', 'B1', 'B2'), -- depression / dip (formal)
  (208012, 'گُسِسته', 'B2', 'C1'), -- torn apart / severed (formal)
  (208015, 'اِستِعلاجی', 'B2', 'C1'), -- sick leave [formal; مرخصی استعلاجی]
  (208016, 'دَجّال', 'B2', 'C1'), -- Antichrist (formal, religious)
  (208017, 'مُتَخَلِّف', 'B1', 'C1'), -- offender / violator (formal, legal)
  (208018, 'پَلَنگی', 'B1', 'C1'), -- leopard-print / leopard-like (formal)
  (208019, 'مَعصومانه', 'B2', 'C1'), -- innocently (formal)
  (208020, 'خوابگَردی', 'B1', 'C1'), -- sleepwalking (formal)
  (208021, 'دُختَرَک', 'B1', 'B2'), -- little girl [affectionate/diminutive] (formal)
  (208022, 'بانجو', 'B1', 'C1'), -- banjo (loanword)
  (208023, 'سَخاوَتمَندی', 'B1', 'B2'), -- generosity (formal)
  (208024, 'شَکیل', 'B2', 'C1'), -- shapely / well-formed (formal)
  (208025, 'پُرخوری', 'B1', 'B2'), -- overeating (formal)
  (208026, 'ناامَن', 'A2', 'B1'), -- unsafe
  (208027, 'تَصادُم', 'B1', 'C1'), -- collision (formal)
  (208028, 'تُرکی', 'A2', 'B1'), -- Turkish [language]
  (208029, 'بالِستیک', 'B2', 'C1'), -- ballistic (formal)
  (208030, 'دَرنَتیجه', 'B1', 'B2'), -- as a result (formal)
  (208031, 'کَنکاش', 'B2', 'C1'), -- investigation / inquiry (formal)
  (208032, 'کَفشدوزَک', 'A1', 'A2'), -- ladybug
  (208034, 'رباتیک', 'B1', 'B2'), -- robotics (loanword)
  (208035, 'شادابی', 'B1', 'C1'), -- vivacity / freshness (formal)
  (208036, 'نابَجا', 'B1', 'C1'), -- misplaced / inappropriate (formal)
  (208038, 'اَبزارآلات', 'B1', 'C1'), -- tools / equipment (formal)
  (208039, 'تونا', 'A2', 'B1'), -- tuna (loanword)
  (208040, 'عِیال', 'B2', 'C1'), -- wife / family dependents (formal)
  (208041, 'کَربوهیدرات', 'B1', 'B2'), -- carbohydrate (loanword)
  (208042, 'رُقَبا', 'B1', 'B2'), -- rivals / competitors (formal, plural of رقیب)
  (208043, 'والا', 'B2', 'C1'), -- lofty / exalted (formal)
  (208044, 'مُشک', 'B2', 'C1'), -- musk (formal, literary)
  (208045, 'تَسلیحاتی', 'B1', 'B2'), -- military / armament-related (formal)
  (208046, 'تیفوس', 'B2', 'C1'), -- typhus (medical)
  (208047, 'روراستی', 'B1', 'C1'), -- honesty / frankness (formal)
  (208048, 'هُلویی', 'B1', 'C1'), -- peach-colored (formal)
  (208049, 'شیلینگ', 'B1', 'B2'), -- shilling [currency] (loanword)
  (208050, 'اِرتِداد', 'B2', 'C1'), -- apostasy (formal, religious)
  (208051, 'اَدیان', 'B1', 'B2'), -- religions (formal, plural of دین)
  (208052, 'سیراب', 'B1', 'C1'), -- quenched / satiated (formal)
  (208053, 'خیسی', 'B1', 'C1'), -- wetness (formal)
  (208054, 'اِنتِظامات', 'B1', 'C1'), -- security / order (formal, organizational)
  (208055, 'وَزیران', 'B1', 'C1'), -- ministers (formal, plural of وزیر)
  (208056, 'رِسالَت', 'B1', 'C1'), -- mission (formal)
  (208057, 'قائِل', 'B2', 'C1'), -- believing / holding (formal; قائل بودن)
  (208058, 'توقُّعات', 'B1', 'C1'), -- expectations (formal)
  (208059, 'فُلانی', 'B1', 'C1'), -- so-and-so (formal)
  (208060, 'تیشه', 'B2', 'C1'), -- adze / hatchet (formal)
  (208061, 'خَزَندگان', 'B1', 'C1'), -- reptiles (formal)
  (208062, 'بُلَندپَروازی', 'B1', 'B2'), -- ambition (formal)
  (208063, 'تأثیرگُذاری', 'B1', 'B2'), -- influence / being influential (formal)
  (208064, 'نَسوز', 'B1', 'C1'), -- fireproof / heat-resistant (formal)
  (208066, 'کَفَن', 'B2', 'C1'), -- shroud [burial] (formal)
  (208067, 'بوتیک', 'A2', 'B1'), -- boutique (loanword)
  (208068, 'کوسِن', 'A2', 'B1'), -- cushion (loanword)
  (208069, 'بید', 'B1', 'B2'), -- willow tree (formal)
  (208070, 'مَقدونی', 'B2', 'C1'), -- Macedonian (nationality)
  (208071, 'سیاسَتمَداری', 'B2', 'C1'), -- statesmanship / politicking (formal)
  (208072, 'نَمناک', 'B1', 'C1'), -- damp / moist (formal)
  (208073, 'اِنضِمام', 'B2', 'C1'), -- annexation / attachment (formal)
  (208075, 'وادی', 'B2', 'C1'), -- valley / realm (formal, literary)
  (208076, 'رَسته', 'B1', 'C1'), -- category / rank (formal)
  (208077, 'اَمیال', 'B2', 'C1'), -- desires (formal, plural of میل)
  (208078, 'سوغات', 'A2', 'B1'), -- souvenir
  (208079, 'چاپخانه', 'B1', 'C1'), -- printing house (formal)
  (208080, 'هَمرَزم', 'B2', 'C1'), -- comrade in arms (formal)
  (208081, 'کَمینگاه', 'B2', 'C1'), -- ambush spot (formal)
  (208082, 'تِکنیسین', 'B1', 'B2'), -- technician (loanword)
  (208083, 'ریحان', 'A2', 'B1'), -- basil
  (208084, 'سَفسَطه', 'B2', 'C1'), -- sophistry / fallacy (formal)
  (208085, 'کِنایه', 'B2', 'C1'), -- irony / allusion (formal, literary)
  (208086, 'اَهریمَنی', 'B2', 'C1'), -- demonic / devilish (formal)
  (208087, 'سوهان', 'B1', 'B2'), -- file [tool]; sohan [traditional candy] (formal)
  (208088, 'تَسخیری', 'B2', 'C1'), -- possessed [formal, e.g. by jinn]
  (208089, 'کِشاله', 'B2', 'C1'), -- groin (formal; کشاله ران)
  (208090, 'یاسَمَن', 'A2', 'B1'), -- jasmine
  (208091, 'صاحِبخانه', 'B1', 'C1'), -- landlord (formal)
  (208092, 'مُخلِص', 'B2', 'C1'), -- sincere / devoted (formal, letter closing)
  (208093, 'نَقداً', 'B1', 'C1'), -- in cash (formal)
  (208094, 'پاسُخگو', 'B1', 'B2'), -- accountable / responsible (formal)
  (208095, 'نژادپَرَستی', 'B1', 'B2'), -- racism (formal)
  (208096, 'اَفسونگَری', 'B2', 'C1'), -- enchantment / allure (formal)
  (208097, 'لازانیا', 'A2', 'B1'), -- lasagna (loanword)
  (208098, 'پوشانِدَن', 'B1', 'B2'), -- to cover / to clothe [causative]
  (208099, 'طِفلَک', 'B1', 'C1'), -- poor thing [affectionate] (formal)
  (208101, 'بازوان', 'B1', 'C1'), -- arms (formal, plural of بازو)
  (208102, 'تَصاعُدی', 'B2', 'C1'), -- progressive / exponential (formal, math)
  (208103, 'نابودکُننده', 'B1', 'C1'), -- destroyer / devastating (formal)
  (208104, 'مَحارِم', 'C1', 'C2'), -- prohibited relations (formal, legal/religious, rare)
  (208105, 'قَلباً', 'B1', 'B2'), -- wholeheartedly / sincerely (formal)
  (208106, 'گِرامَر', 'A2', 'B1'), -- grammar (loanword)
  (208107, 'وانیل', 'A2', 'B1'), -- vanilla (loanword)
  (208108, 'شوفاژ', 'B1', 'C1'), -- radiator [heating] (loanword)
  (208109, 'اِعاده', 'B2', 'C1'), -- restoration / reinstatement (formal, legal)
  (208110, 'بَلدَرچین', 'A2', 'B1'), -- quail
  (208111, 'پیکار', 'B2', 'C1'), -- battle / struggle (formal)
  (208112, 'پادکَست', 'A2', 'B1'), -- podcast (loanword)
  (208113, 'آماتوری', 'B1', 'C1'), -- amateur [adjective] (formal)
  (208114, 'آنانی', 'B2', 'C1'), -- those who (formal, literary)
  (208115, 'سَنگفَرش', 'B1', 'C1'), -- pavement / cobblestone (formal)
  (208116, 'دَولَتمَردان', 'B2', 'C1'), -- statesmen (formal)
  (208117, 'قاصِدَک', 'A2', 'B1'), -- dandelion
  (208118, 'مَغفِرَت', 'B2', 'C1'), -- forgiveness (formal, religious)
  (208119, 'مژده', 'B2', 'C1'), -- good news (formal, literary)
  (208120, 'بامپِر', 'B1', 'C1'), -- bumper [car] (loanword)
  (208121, 'چالِشی', 'B1', 'B2'), -- challenging (formal)
  (208122, 'طَبَقاتی', 'B2', 'C1'), -- class-related (formal, social)
  (208123, 'ایهام', 'C1', 'C2'), -- ambiguity / double meaning (formal, literary, rare)
  (208124, 'اِختِصار', 'B1', 'C1'), -- abbreviation / brevity (formal)
  (208125, 'سوسیالیسم', 'B1', 'C1'), -- socialism (loanword)
  (208126, 'سیاهچاله', 'B1', 'B2'), -- black hole [astronomy] (formal)
  (208127, 'فَعّالانه', 'B1', 'C1'), -- actively (formal)
  (208128, 'مُعامِلاتی', 'B1', 'C1'), -- transactional / trading (formal)
  (208131, 'اَقسام', 'B1', 'C1'), -- kinds / types (formal, plural of قسم)
  (208133, 'فاحِش', 'B2', 'C1'), -- flagrant / blatant (formal)
  (208134, 'کَرنا', 'B2', 'C1'), -- horn / trumpet [traditional] (formal)
  (208135, 'اَغذیه', 'B2', 'C1'), -- foods (formal, plural of غذا)
  (208136, 'خَلأ', 'B2', 'C1'), -- vacuum / void (formal)
  (208137, 'زَجرآوَر', 'B2', 'C1'), -- agonizing / painful (formal)
  (208138, 'دینار', 'B1', 'B2'), -- dinar [currency] (formal)
  (208140, 'مِناره', 'B1', 'C1'), -- minaret (formal)
  (208141, 'هَدایا', 'B1', 'B2'), -- gifts (formal, plural of هدیه)
  (208142, 'اِمامزاده', 'B2', 'C1'), -- imamzadeh [shrine] (formal)
  (208144, 'اِنصافاً', 'B1', 'B2'), -- honestly / fairly (formal)
  (208145, 'کُنتِس', 'B2', 'C1'), -- countess (formal, loanword)
  (208146, 'مُنتَصِب', 'B2', 'C1'), -- appointed (formal)
  (208147, 'سارین', 'C1', 'C2'), -- sarin [nerve gas] (formal, rare)
  (208148, 'روشَنفِکرانه', 'B2', 'C1'), -- intellectually (formal)
  (208149, 'آدرنالین', 'B1', 'B2'), -- adrenaline (loanword)
  (208150, 'چکیده', 'B1', 'C1'), -- abstract / summary (formal)
  (208151, 'کَرَفس', 'A2', 'B1'), -- celery
  (208152, 'نَمَکدان', 'A2', 'B2'), -- salt shaker
  (208153, 'بَهادُر', 'B2', 'C1'), -- brave / valiant (formal, literary)
  (208154, 'نُخودی', 'B1', 'B2'), -- chickpea-colored / light beige (formal)
  (208155, 'اِکتِفا', 'B1', 'C1'), -- sufficing / being content with (formal)
  (208156, 'رومیزی', 'A2', 'B1'), -- tablecloth
  (208157, 'چَهارپایه', 'A2', 'B1'), -- stool [furniture]
  (208158, 'کارِبران', 'B1', 'C1'), -- users (formal, plural of کاربر)
  (208159, 'کَفپوش', 'B1', 'C1'), -- flooring (formal)
  (208160, 'گَرداننده', 'B1', 'C1'), -- host / operator (formal)
  (208161, 'مَعلومات', 'B1', 'C1'), -- information / knowledge (formal)
  (208163, 'رُباتی', 'B1', 'B2'), -- robotic (formal)
  (208164, 'مُقَرَّری', 'B2', 'C1'), -- salary / stipend (formal)
  (208165, 'لَله', 'B2', 'C1'), -- nanny / governess (formal, historical/literary)
  (208166, 'صُبحگاه', 'B2', 'C1'), -- morning (formal, literary)
  (208167, 'پیرامونی', 'B1', 'C1'), -- surrounding / peripheral (formal)
  (208168, 'قاپیدَن', 'B1', 'B2'), -- to snatch / to grab
  (208169, 'فَرزانگی', 'B2', 'C1'), -- wisdom / sagacity (formal, literary)
  (208170, 'سَلیطه', 'B2', 'C1'), -- shrew / nagging woman (formal, derogatory)
  (208171, 'زیرِخاکی', 'B2', 'C1'), -- buried / underground (formal, figurative)
  (208172, 'شِراکَتی', 'B1', 'C1'), -- partnership-related (formal)
  (208173, 'لامَذهَب', 'B2', 'C2'), -- irreligious / godless (formal)
  (208174, 'سِرسام', 'B2', 'C1'), -- meningitis [old term] / dizziness (formal)
  (208175, 'سایرن', 'B1', 'C1'), -- siren (loanword)
  (208176, 'اَسرا', 'B2', 'C1'), -- captives (formal, plural of اسیر)
  (208177, 'زَهری', 'B1', 'C1'), -- poisonous (formal)
  (208178, 'خودسَری', 'B2', 'C1'), -- willfulness / high-handedness (formal)
  (208179, 'لَبان', 'B2', 'C2'), -- lips (formal, literary, plural of لب)
  (208180, 'مَعذور', 'B2', 'C2'), -- excused / exempted (formal)
  (208181, 'بی‌خَبَر', 'B1', 'C1'), -- unaware / uninformed (formal)
  (208182, 'سِتیزه', 'B2', 'C1'), -- conflict / strife (formal, literary)
  (208183, 'سودمَندی', 'B1', 'C1'), -- usefulness (formal)
  (208184, 'خواروبار', 'B1', 'C1'), -- groceries (formal)
  (208185, 'دَوَندگی', 'B1', 'C1'), -- running around [errands] (formal)
  (208186, 'بی‌رَحمی', 'B1', 'B2'), -- cruelty (formal)
  (208187, 'قَزاق', 'B2', 'C2'), -- Cossack (formal, historical)
  (208188, 'تَفهیم', 'B2', 'C1'), -- making understood / explaining (formal)
  (208189, 'وُزَرا', 'B1', 'C1'), -- ministers (formal, plural of وزیر)
  (208190, 'خودجوش', 'B1', 'C1'), -- spontaneous / self-motivated (formal)
  (208191, 'پُررویی', 'B1', 'C1'), -- impudence / audacity (formal)
  (208192, 'غِشا', 'B2', 'C2'), -- membrane (formal, biology)
  (208193, 'فِشارخون', 'B1', 'C1'), -- blood pressure (formal)
  (208194, 'ژوئیه', 'B2', 'C1'), -- July [French calendar month name] (formal)
  (208196, 'ماهیانه', 'B1', 'B2'), -- monthly (formal)
  (208197, 'پارتیزانی', 'B2', 'C1'), -- partisan / guerrilla [adjective] (formal)
  (208198, 'پُلیمِر', 'B2', 'C1'), -- polymer (loanword)
  (208199, 'هَمگَرایی', 'B2', 'C1'), -- convergence (formal)
  (208200, 'دورنَما', 'B1', 'C1'), -- prospect / outlook (formal)
  (208201, 'باربیکیو', 'A2', 'B1'), -- barbecue (loanword)
  (208202, 'مَلموس', 'B1', 'C1'), -- tangible (formal)
  (208203, 'پولَکی', 'B2', 'C1'), -- sequined / glittery (formal)
  (208205, 'سَرتاپا', 'B1', 'C1'), -- from head to toe (formal)
  (208206, 'نَشریات', 'B1', 'C1'), -- publications (formal, plural of نشریه)
  (208207, 'مَعلولیَّت', 'B1', 'B2'), -- disability (formal)
  (208208, 'دَمیدَن', 'B1', 'B2'), -- to blow / to dawn (formal)
  (208210, 'رَمَق', 'B2', 'C2'), -- strength / energy (formal; بی‌رمق)
  (208211, 'صِحّه', 'B2', 'C2'), -- confirmation (formal; صحه گذاشتن)
  (208212, 'پاوَرچین', 'B2', 'C1'), -- tiptoeing (formal; پاورچین راه رفتن)
  (208213, 'اَشَد', 'B2', 'C1'), -- most severe (formal, legal; اشد مجازات)
  (208214, 'رازآلود', 'B2', 'C2'), -- mysterious / enigmatic (formal)
  (208215, 'باطِنی', 'B2', 'C1'), -- inner / internal (formal, spiritual)
  (208217, 'هاوَن', 'B1', 'B2'), -- mortar [cooking tool] (formal)
  (208218, 'رَمه', 'B1', 'C1'), -- flock / herd (formal)
  (208219, 'آهَنگَری', 'B2', 'C1'), -- blacksmithing (formal)
  (208220, 'گَرانقیمَت', 'B1', 'C1'), -- expensive / valuable (formal)
  (208223, 'اینچُنین', 'B2', 'C1'), -- such / like this (formal)
  (208224, 'اَکید', 'B2', 'C1'), -- strict / emphatic (formal)
  (208225, 'آبشُش', 'B1', 'C1'), -- gill [fish] (formal)
  (208226, 'رُفتِگی', 'B1', 'B2'), -- sanitation worker / street sweeper (formal)
  (208227, 'سُرخپوست', 'B2', 'C1'), -- Native American (formal, dated term)
  (208228, 'بِریانی', 'A2', 'B1'), -- biryani (loanword)
  (208229, 'قَدّیسه', 'B2', 'C1'), -- female saint (formal, religious)
  (208230, 'قافِله', 'B1', 'C1'), -- caravan (formal)
  (208231, 'مَحزون', 'B2', 'C2'), -- sorrowful / melancholic (formal)
  (208232, 'گَرمایِش', 'B1', 'B2'), -- warming / heating (formal)
  (208233, 'جوابیه', 'B2', 'C1'), -- response / rebuttal (formal, legal/press)
  (208234, 'عَقبگَرد', 'B1', 'C1'), -- retreat / regression (formal)
  (208235, 'دامادی', 'B2', 'C1'), -- being a groom / son-in-law status (formal)
  (208236, 'پَرتابگَر', 'B2', 'C2'), -- launcher / thrower (formal)
  (208237, 'فَقیران', 'B2', 'C1'), -- the poor (formal, plural of فقیر)
  (208238, 'فَتق', 'B2', 'C1'), -- hernia (medical)
  (208239, 'بَم', 'B2', 'C1'), -- deep / bass [sound] (formal)
  (208240, 'فَضولات', 'B2', 'C2'), -- excrement / waste (formal)
  (208241, 'کارمُزد', 'B1', 'C1'), -- fee / commission (formal)
  (208242, 'قَدکوتاه', 'B1', 'C1'), -- short [in height] (formal)
  (208243, 'اَجر', 'B2', 'C2'), -- reward (formal, religious)
  (208244, 'هَمخواب', 'B2', 'C2'), -- bedmate / sexual partner (formal)
  (208245, 'تَدارُک', 'B1', 'B2'), -- preparation / provision (formal)
  (208246, 'گیرایی', 'B1', 'C1'), -- attractiveness / charisma (formal)
  (208247, 'مُستَغَلات', 'B2', 'C2'), -- real estate (formal, legal)
  (208248, 'اسکیزوفرنی', 'B2', 'C1'), -- schizophrenia (loanword)
  (208249, 'راستا', 'B1', 'C1'), -- direction / line (formal; در راستای)
  (208250, 'پَریزاد', 'B2', 'C2'), -- fairy-born / beautiful (formal, literary)
  (208251, 'جکوزی', 'A2', 'B1'), -- jacuzzi (loanword)
  (208252, 'مُتَوَفّی', 'B2', 'C1'), -- the deceased (formal, legal)
  (208254, 'تَوابِع', 'B2', 'C2'), -- functions (formal, math, plural of تابع)
  (208255, 'سَهواً', 'B1', 'B2'), -- unintentionally (formal)
  (208256, 'سَرخَس', 'B1', 'C1'), -- fern (formal)
  (208257, 'شَرابی', 'B1', 'B2'), -- wine-colored (formal)
  (208258, 'موسیقیایی', 'B1', 'C1'), -- musical (formal)
  (208259, 'طاهِر', 'B2', 'C2'), -- pure / clean (formal, literary)
  (208260, 'قامَت', 'B1', 'C1'), -- stature / figure (formal, literary)
  (208261, 'پِسَردایی', 'A2', 'B1'), -- maternal uncle's son [cousin]
  (208262, 'پاتیل', 'B1', 'B2'), -- large cooking pot (formal)
  (208263, 'تَبَرُّک', 'B2', 'C1'), -- blessing (formal, religious)
  (208264, 'پُرحَرارَت', 'B2', 'C1'), -- passionate / heated (formal)
  (208265, 'فَلات', 'B1', 'C1'), -- plateau [geography] (formal)
  (208267, 'ویرایِشگَر', 'B1', 'C1'), -- editor [software] (formal)
  (208268, 'تَلنبار', 'B2', 'C2'), -- piled up / stacked (formal)
  (208270, 'بَدخُلقی', 'B1', 'B2'), -- bad temper (formal)
  (208271, 'هِدایَتگَر', 'B2', 'C1'), -- guide / leader (formal)
  (208272, 'جَوایِز', 'B1', 'B2'), -- prizes / awards (formal, plural of جایزه)
  (208273, 'جَنّات', 'B2', 'C2'), -- gardens (formal, religious, plural of جنت)
  (208274, 'گُشایِش', 'B1', 'C1'), -- opening / inauguration (formal)
  (208275, 'بارنامه', 'B2', 'C2'), -- bill of lading / waybill (formal)
  (208276, 'اوتیسم', 'B1', 'B2'), -- autism (loanword)
  (208277, 'غَیرضَروری', 'B1', 'B2'), -- unnecessary (formal)
  (208278, 'گُمنامی', 'B1', 'C1'), -- anonymity (formal)
  (208279, 'نَقیض', 'B2', 'C1'), -- contradiction / opposite (formal, logic)
  (208280, 'قَنّاد', 'B1', 'C1'), -- confectioner / pastry chef (formal)
  (208282, 'کوکی', 'A2', 'B1'), -- cookie (loanword)
  (208283, 'کَنه', 'B1', 'A2'), -- tick [insect] (formal)
  (208284, 'بَربَری', 'A2', 'B1'), -- barbari [flatbread]; barbarian
  (208285, 'مُصِرّانه', 'B2', 'C1'), -- insistently (formal)
  (208286, 'سَرآشپَزی', 'B1', 'C1'), -- head-chef profession (formal)
  (208287, 'اَفشانه', 'B2', 'C2'), -- spray (formal)
  (208288, 'اَساتید', 'B1', 'B2'), -- professors (formal, plural of استاد)
  (208289, 'تَبعیدی', 'B1', 'C1'), -- exiled [person] (formal)
  (208290, 'اِضطِرار', 'B1', 'C1'), -- emergency / urgency (formal)
  (208291, 'ناآرامی', 'B1', 'C1'), -- unrest / turmoil (formal)
  (208292, 'آرتروز', 'B2', 'C2'), -- arthritis (medical, loanword)
  (208293, 'اِستِعدادیابی', 'B2', 'C1'), -- talent scouting (formal)
  (208294, 'چیستان', 'B1', 'C1'), -- riddle (formal)
  (208295, 'گُسِستگی', 'B2', 'C1'), -- disconnection / fragmentation (formal)
  (208296, 'گِرانیت', 'B1', 'C1'), -- granite (loanword)
  (208297, 'مُکَرَّراً', 'B1', 'B2'), -- repeatedly (formal)
  (208298, 'اِلتِزام', 'B2', 'C2'), -- commitment / obligation (formal)
  (208299, 'وارَفته', 'B2', 'C2'), -- listless / limp (formal)
  (208300, 'مُستَنَدات', 'B1', 'C1'), -- documentation / documents (formal)
  (208301, 'بیومتریک', 'B2', 'C1'), -- biometric (formal)
  (208302, 'دورتادور', 'B2', 'C2'), -- all around (formal)
  (208303, 'مُستَدَل', 'B2', 'C2'), -- well-reasoned / logical (formal)
  (208304, 'ایزَد', 'B2', 'C2'), -- God / deity (formal, literary)
  (208305, 'مَرموزانه', 'B2', 'C2'), -- mysteriously (formal)
  (208306, 'زِناکار', 'B2', 'C1'), -- adulterer (formal)
  (208307, 'چِشایی', 'B2', 'C1'), -- gustatory / taste (formal; حس چشایی)
  (208309, 'اِضطِرابی', 'B1', 'C1'), -- anxiety-related (formal)
  (208310, 'مَدهوش', 'B2', 'C2'), -- unconscious / dazed (formal)
  (208311, 'بَدَنساز', 'B1', 'C1'), -- bodybuilder (formal)
  (208312, 'دُرنا', 'B2', 'C2'), -- crane [bird] (formal, literary)
  (208313, 'اِسراف', 'B2', 'C2'), -- extravagance / wastefulness (formal)
  (208314, 'سوزناک', 'B2', 'C1'), -- poignant / heart-wrenching (formal)
  (208315, 'شَفاعَت', 'B2', 'C2'), -- intercession (formal, religious)
  (208316, 'مِزاح', 'B2', 'C1'), -- joking / banter (formal)
  (208317, 'لابه', 'B2', 'C2'), -- pleading / imploring (formal)
  (208318, 'مُنزَجِرکُننده', 'B2', 'C2'), -- disgusting / repellent (formal)
  (208319, 'رِفلِکس', 'B1', 'C1'), -- reflex (loanword)
  (208320, 'خَطیر', 'B2', 'C1'), -- critical / momentous (formal)
  (208321, 'اَقساط', 'B1', 'C1'), -- installments (formal, plural of قسط)
  (208322, 'آخوندَک', 'B1', 'C1'), -- praying mantis (formal)
  (208323, 'فوتون', 'B2', 'C2'), -- photon (loanword)
  (208324, 'وَهله', 'B2', 'C1'), -- instance / stage (formal; در وهله اول)
  (208325, 'فَرط', 'B2', 'C2'), -- excess (formal; از فرط)
  (208326, 'سِپَهبَد', 'B2', 'C2'), -- lieutenant general [military rank] (formal)
  (208327, 'مُتَذَکِّر', 'B2', 'C1'), -- reminding / pointing out (formal)
  (208328, 'آکادمیک', 'B1', 'C1'), -- academic (loanword)
  (208329, 'مَقدور', 'B2', 'C2'), -- possible / feasible (formal)
  (208330, 'قَضاوَتی', 'B1', 'B2'), -- judgmental (formal)
  (208331, 'کاریابی', 'B1', 'C1'), -- job placement / employment agency (formal)
  (208332, 'خاطِرجَمع', 'B1', 'C1'), -- assured / confident (formal)
  (208333, 'نوشین', 'B2', 'C1'), -- sweet / pleasant (formal, literary)
  (208334, 'بَدقَواره', 'B2', 'C2'), -- misshapen / ill-proportioned (formal)
  (208335, 'دَریده', 'B2', 'C1'), -- torn / shameless (formal)
  (208336, 'دُخانیات', 'B2', 'C1'), -- tobacco products (formal)
  (208337, 'خودراضی', 'B2', 'C1'), -- self-satisfied / complacent (formal)
  (208338, 'کَمَری', 'B2', 'C1'), -- lumbar / waist-related (formal)
  (208339, 'اَنبوهی', 'B2', 'C1'), -- abundance / mass (formal)
  (208340, 'بَرآمَده', 'B2', 'C2'), -- protruding / arisen (formal)
  (208341, 'کاتِب', 'B2', 'C2'), -- scribe (formal)
  (208342, 'کِششی', 'B2', 'C1'), -- tensile / pulling (formal)
  (208343, 'طَبعاً', 'B1', 'C1'), -- naturally (formal)
  (208344, 'پَهلَوان', 'B1', 'C1'), -- champion / hero (formal, literary)
  (208345, 'گیربُکس', 'B1', 'C1'), -- gearbox (loanword)
  (208346, 'دِلبَسته', 'B1', 'C1'), -- attached / fond of (formal)
  (208347, 'یَقیناً', 'B1', 'B2'), -- certainly (formal)
  (208348, 'چَترِ نَجات', 'B1', 'B2'), -- parachute
  (208349, 'بَدریخت', 'B1', 'C1'), -- ugly / misshapen (formal)
  (208350, 'فلامینگو', 'A2', 'B1'), -- flamingo (loanword)
  (208351, 'سار', 'B2', 'C2'), -- starling [bird] (formal)
  (208352, 'مِهتَر', 'B2', 'C2'), -- elder / senior (formal, literary)
  (208353, 'اُتومات', 'B1', 'C1'), -- automatic (loanword)
  (208354, 'مُتَقَبِّل', 'B2', 'C2'), -- undertaking / assuming (formal; متقبل شدن)
  (208355, 'دَفتَردار', 'B2', 'C1'), -- bookkeeper / clerk (formal)
  (208357, 'مِریزاد', 'B2', 'C1'), -- well done! (formal; دست‌مریزاد)
  (208358, 'تَصویربَرداری', 'B1', 'C1'), -- imaging (formal, medical/photography)
  (208359, 'دِهلیز', 'B2', 'C1'), -- atrium [heart] / vestibule / corridor (formal)
  (208360, 'زیرپوستی', 'B2', 'C1'), -- subcutaneous; subtle (formal, figurative)
  (208361, 'غَیرمُستَقیم', 'B1', 'C1'), -- indirect (formal)
  (208363, 'سَرجَمع', 'B1', 'C1'), -- in total (formal)
  (208364, 'گَزافه', 'B2', 'C2'), -- exaggeration / excessive claim (formal)
  (208366, 'حِضانَت', 'B2', 'C1'), -- custody [legal] (formal)
  (208367, 'پاسبان', 'B1', 'B2'), -- policeman [old term] (formal)
  (208368, 'شِکارگاه', 'B2', 'C1'), -- hunting ground (formal)
  (208369, 'طَلَبکار', 'B1', 'C1'), -- creditor (formal)
  (208370, 'عَربَده', 'B2', 'C2'), -- shouting / yelling (formal)
  (208371, 'تَزریقی', 'B1', 'C1'), -- injectable (formal)
  (208372, 'زَری', 'B2', 'C1'), -- gold brocade fabric (formal)
  (208373, 'گَزاره', 'B2', 'C2'), -- proposition / statement (formal, logic)
  (208375, 'هُویَّتی', 'B1', 'B2'), -- identity-related (formal)
  (208376, 'جُنبَنده', 'B2', 'C1'), -- moving creature / animal (formal)
  (208377, 'چَندساله', 'B1', 'C1'), -- how many years old / several years
  (208378, 'غَیرِانتِفاعی', 'B1', 'C1'), -- non-profit (formal)
  (208379, 'مِنبَر', 'B2', 'C2'), -- pulpit (formal, religious)
  (208380, 'پولساز', 'B1', 'C1'), -- money-making (formal)
  (208381, 'حُکمی', 'B2', 'C1'), -- judicial / decree-related (formal)
  (208382, 'پَراکَندگی', 'B1', 'C1'), -- dispersion / scatter (formal)
  (208383, 'چکاپ', 'A2', 'B1'), -- checkup [medical] (loanword)
  (208385, 'کَمَند', 'B2', 'C2'), -- lasso (formal, literary)
  (208386, 'موازِنه', 'B1', 'C1'), -- balance / equilibrium (formal)
  (208387, 'چارچِشمی', 'B2', 'C2'), -- eagerly watching (formal; چارچشمی نگاه کردن)
  (208388, 'هادی', 'B2', 'C1'), -- guide (formal, literary)
  (208390, 'قَصَبه', 'B2', 'C2'), -- small town (formal)
  (208391, 'صَدپا', 'B1', 'C1'), -- centipede (formal)
  (208392, 'اَفضَل', 'B2', 'C2'), -- superior / best (formal)
  (208393, 'ثانَوی', 'B1', 'B2'), -- secondary (formal)
  (208394, 'کیمونو', 'A2', 'B1'), -- kimono (loanword)
  (208395, 'بافتَنی', 'B1', 'C1'), -- knitting / knitted item (formal)
  (208396, 'تَدابیر', 'B1', 'B2'), -- measures / precautions (formal, plural of تدبیر)
  (208397, 'سِنتز', 'B2', 'C2'), -- synthesis (formal, chemistry, loanword)
  (208398, 'تَندیس', 'B1', 'B2'), -- statue / sculpture (formal)
  (208399, 'زیارَتگاه', 'B2', 'C1'), -- pilgrimage site (formal)
  (208400, 'دَرویش', 'B2', 'C1'), -- dervish (formal, literary)
  (208401, 'وَساطَت', 'B2', 'C2'), -- mediation (formal)
  (208402, 'قوچ', 'A2', 'B1'), -- ram [animal]
  (208403, 'وَقاحَت', 'B2', 'C2'), -- impudence / insolence (formal)
  (208404, 'لاعِلاج', 'B2', 'C2'), -- incurable (formal, medical)
  (208405, 'لَوحه', 'B2', 'C2'), -- plaque / tablet (formal)
  (208406, 'شیب‌دار', 'B1', 'C1'), -- sloped / inclined (formal)
  (208407, 'عار', 'B2', 'C2'), -- shame / disgrace (formal)
  (208408, 'کَفالَت', 'B2', 'C1'), -- guardianship / sponsorship (formal, legal)
  (208409, 'اِلهامی', 'B2', 'C1'), -- inspirational (formal)
  (208410, 'حَصیر', 'B1', 'C1'), -- mat / wicker (formal)
  (208411, 'مُصادِف', 'B2', 'C2'), -- coinciding (formal)
  (208412, 'تِریلی', 'A2', 'B1'), -- trailer [truck] (loanword)
  (208413, 'گِردآوَری', 'B1', 'C1'), -- compilation / gathering (formal)
  (208414, 'تِروما', 'B1', 'C1'), -- trauma (formal, psychology, loanword)
  (208415, 'آمیخته', 'B1', 'B2'), -- mixed / blended (formal)
  (208416, 'اِنتِظامی', 'B1', 'C1'), -- law enforcement [adjective] (formal)
  (208418, 'صُعودی', 'B1', 'C1'), -- ascending (formal)
  (208419, 'نامیرا', 'B2', 'C1'), -- immortal (formal, literary)
  (208422, 'پِلیکان', 'A2', 'B1'), -- pelican (loanword)
  (208423, 'هُجومی', 'B2', 'C1'), -- offensive / aggressive (formal)
  (208424, 'مارگیر', 'B2', 'C2'), -- snake charmer (formal)
  (208425, 'تِمثال', 'B2', 'C2'), -- image / portrait (formal, religious)
  (208426, 'تَشویقی', 'B1', 'C1'), -- encouraging / incentive (formal)
  (208428, 'سَطر', 'B1', 'C1'), -- line [text] (formal)
  (208429, 'خَیرخواهانه', 'B2', 'C1'), -- benevolently (formal)
  (208430, 'پیشبَرد', 'B1', 'B2'), -- advancement / promotion (formal)
  (208431, 'مُستَخدَمین', 'B2', 'C1'), -- servants / employees (formal, plural)
  (208432, 'فَرز', 'B1', 'B2'), -- quick / agile (formal)
  (208434, 'تورنمنت', 'B1', 'C1'), -- tournament (loanword)
  (208435, 'یادبودی', 'B1', 'C1'), -- memorial [adjective] (formal)
  (208436, 'تَشَنُّجی', 'B2', 'C1'), -- convulsive / tense (formal)
  (208437, 'تابان', 'B2', 'C1'), -- shining / radiant (formal, literary)
  (208438, 'پَرچَمدار', 'B1', 'C1'), -- flag-bearer (formal)
  (208439, 'مُربّی‌گَری', 'B1', 'B2'), -- coaching [profession] (formal)
  (208440, 'بُلَندمُدَّت', 'B1', 'C1'), -- long-term (formal)
  (208441, 'صَحن', 'B2', 'C2'), -- courtyard (formal, esp. shrine)
  (208443, 'لایک', 'A2', 'B1'), -- like [social media] (loanword)
  (208444, 'ماژور', 'B2', 'C2'), -- major [music/military] (loanword)
  (208445, 'هَرازگاهی', 'B2', 'C1'), -- occasionally (formal)
  (208446, 'اسیدی', 'B1', 'B2'), -- acidic (formal)
  (208447, 'رُؤیَت', 'B2', 'C1'), -- sighting / observation (formal)
  (208448, 'پَهنا', 'B1', 'C1'), -- width (formal)
  (208449, 'سَعادَتمَند', 'B2', 'C2'), -- fortunate / happy (formal)
  (208450, 'سَجده', 'B2', 'C2'), -- prostration (formal, religious)
  (208451, 'فِرفِری', 'A2', 'B1'), -- curly [hair]
  (208452, 'فَواصِل', 'B1', 'C1'), -- distances / intervals (formal, plural of فاصله)
  (208453, 'اِبهامات', 'B2', 'C2'), -- ambiguities (formal)
  (208454, 'نای', 'B2', 'C1'), -- windpipe / trachea (formal, medical)
  (208455, 'بَعضاً', 'B1', 'C1'), -- sometimes (formal)
  (208456, 'پوسیدَن', 'B1', 'B2'), -- to rot / to decay
  (208457, 'موذیانه', 'B2', 'C1'), -- cunningly / deceitfully (formal)
  (208458, 'گیاه‌خواری', 'B1', 'C1'), -- vegetarianism (formal)
  (208459, 'اَفراشته', 'B2', 'C2'), -- raised / hoisted (formal, flag)
  (208460, 'گوشتالو', 'B2', 'C2'), -- chubby / plump (formal)
  (208461, 'مُتَفَرِّقه', 'B2', 'C2'), -- miscellaneous (formal)
  (208462, 'پِلاسما', 'B2', 'C1'), -- plasma (loanword)
  (208463, 'پُرسود', 'B1', 'C1'), -- profitable (formal)
  (208464, 'نیشخَند', 'B2', 'C1'), -- smirk / sneer (formal)
  (208465, 'پیل', 'B2', 'C1'), -- elephant (formal, literary); battery
  (208466, 'اَبدان', 'B2', 'C1'), -- bodies (formal, plural of بدن)
  (208467, 'میانجی', 'B2', 'C1'), -- mediator (formal)
  (208468, 'پِستاندار', 'B1', 'B2'), -- mammal (formal)
  (208469, 'ماندَنی', 'B2', 'C1'), -- lasting / enduring (formal)
  (208470, 'جَلیل', 'B2', 'C1'), -- glorious / majestic (formal)
  (208471, 'خواهَرانه', 'B2', 'C2'), -- sisterly (formal)
  (208472, 'فایبِر', 'B1', 'C1'), -- fiber (loanword)
  (208473, 'کُنکور', 'B1', 'C1'), -- entrance exam (formal)
  (208474, 'نِگارِش', 'B1', 'C1'), -- writing / composition (formal)
  (208475, 'چیتا', 'A2', 'B1'), -- cheetah
  (208476, 'دوپینگ', 'B1', 'C1'), -- doping [sports] (formal)
  (208477, 'جِداره', 'B2', 'C2'), -- wall / lining (formal, technical)
  (208478, 'خوشگُذَرانی', 'B1', 'C1'), -- having fun / merrymaking (formal)
  (208479, 'فیله', 'B1', 'B2'), -- fillet [meat] (loanword)
  (208480, 'تَنبیهی', 'B2', 'C1'), -- punitive (formal)
  (208481, 'باخَبَری', 'B1', 'C1'), -- being informed (formal)
  (208482, 'مُنعَکِس', 'B1', 'B2'), -- reflected (formal)
  (208483, 'خیزِش', 'B1', 'C1'), -- uprising (formal)
  (208484, 'عَدَسی', 'B1', 'B2'), -- lens (formal, optics)
  (208485, 'آمپِر', 'B1', 'C1'), -- ampere (loanword)
  (208486, 'زیرَکی', 'B1', 'B2'), -- shrewdness / cleverness (formal)
  (208487, 'اَثَرگُذار', 'B1', 'C1'), -- influential / effective (formal)
  (208488, 'نافِذ', 'B2', 'C2'), -- penetrating / authoritative (formal)
  (208489, 'شُله', 'B2', 'C1'), -- porridge / stew (formal)
  (208490, 'رَسانا', 'B1', 'C1'), -- conductor [electricity] (formal)
  (208491, 'کَربُنات', 'B2', 'C2'), -- carbonate (formal, chemistry)
  (208492, 'مُستَعمَراتی', 'B2', 'C1'), -- colonial (formal)
  (208493, 'مَنزِلگاه', 'B2', 'C2'), -- abode / dwelling place (formal, literary)
  (208494, 'کانتِینِر', 'B1', 'B2'), -- container (loanword)
  (208495, 'سَحَرخیز', 'B1', 'C1'), -- early riser (formal)
  (208496, 'جَنگاوَری', 'B2', 'C1'), -- warriorship / combat skill (formal)
  (208497, 'بُنجُل', 'B2', 'C1'), -- junk / shoddy goods (formal)
  (208498, 'غافِلگیرکُننده', 'B1', 'B2'), -- surprising (formal)
  (208499, 'دَستپاچگی', 'B1', 'C1'), -- flustering / nervousness (formal)
  (208500, 'فیروزه', 'B1', 'C1'), -- turquoise (formal)
  (208501, 'شُبان', 'B2', 'C2'), -- shepherd (formal, literary)
  (208502, 'اِملا', 'B1', 'C1'), -- spelling (formal)
  (208503, 'ریموت', 'A2', 'B1'), -- remote [control] (loanword)
  (208504, 'سِنین', 'B1', 'B2'), -- ages (formal, plural of سن)
  (208507, 'خال‌دار', 'B1', 'C1'), -- spotted [pattern] (formal)
  (208508, 'زین', 'B2', 'C1'), -- saddle (formal)
  (208510, 'تَنگی', 'B2', 'C1'), -- narrowness / tightness (formal)
  (208511, 'اُتاقَک', 'B1', 'B2'), -- small room / booth (formal)
  (208512, 'رُخصَت', 'B2', 'C2'), -- permission / leave (formal, literary)
  (208513, 'بَنّایی', 'B1', 'C1'), -- masonry / construction work (formal)
  (208514, 'کبالت', 'B1', 'C1'), -- cobalt (formal, chemistry, loanword)
  (208515, 'اگزما', 'B2', 'C2'), -- eczema (medical, loanword)
  (208516, 'قَهقَهه', 'B1', 'C1'), -- loud laughter / guffaw (formal)
  (208517, 'نَسَنجیده', 'B2', 'C1'), -- ill-considered / rash (formal)
  (208518, 'قُوا', 'B2', 'C1'), -- forces (formal, plural of قوه)
  (208519, 'تَعلیقی', 'B2', 'C1'), -- suspended (formal, legal)
  (208520, 'چَرخِشی', 'B1', 'B2'), -- rotational (formal)
  (208521, 'شِتابان', 'B2', 'C2'), -- hurrying / hasty (formal, literary)
  (208522, 'خُردسال', 'B2', 'C2'), -- young / of tender age (formal)
  (208523, 'ویراستاری', 'B1', 'C1'), -- editing (formal)
  (208524, 'زیوَر', 'B2', 'C2'), -- ornament / adornment (formal)
  (208525, 'غُرولَند', 'B1', 'C1'), -- grumbling / muttering (formal)
  (208526, 'هَمزَن', 'A2', 'B1'), -- mixer / whisk [kitchen]
  (208527, 'آفات', 'B2', 'C2'), -- pests / blights (formal, agricultural)
  (208528, 'بالاتَنه', 'B2', 'C2'), -- upper body / torso (formal)
  (208529, 'لَم', 'B2', 'C1'), -- lounging / reclining (formal; لم دادن)
  (208530, 'طَویل', 'B2', 'C2'), -- long (formal, literary)
  (208531, 'گارسون', 'B1', 'B2'), -- waiter (loanword)
  (208532, 'سوسیالیست', 'B1', 'B2'), -- socialist (loanword)
  (208533, 'عالی‌رُتبه', 'B2', 'C2'), -- high-ranking (formal)
  (208534, 'مُثمِر', 'B2', 'C2'), -- fruitful (formal; مثمر ثمر)
  (208535, 'اَولیا', 'B2', 'C1'), -- guardians / saints (formal, plural of ولی)
  (208536, 'جَناغ', 'B2', 'C2'), -- wishbone (formal)
  (208537, 'لیسیدَن', 'B1', 'B2'), -- to lick
  (208538, 'بَدشگون', 'B2', 'C2'), -- ill-omened / inauspicious (formal)
  (208539, 'تَزکیه', 'B2', 'C2'), -- purification (formal; تزکیه نفس)
  (208540, 'حَلقَوی', 'B2', 'C1'), -- circular / ring-shaped (formal)
  (208541, 'فریبکاری', 'B1', 'B2'), -- deception / trickery (formal)
  (208542, 'کُلاهخود', 'B2', 'C2'), -- helmet [historical/military] (formal)
  (208543, 'نامُرتَبِط', 'B1', 'C1'), -- unrelated (formal)
  (208544, 'ناامیدکُننده', 'B1', 'B2'), -- disappointing (formal)
  (208547, 'جوشانده', 'B2', 'C2'), -- decoction / brewed drink (formal)
  (208548, 'مُحاسِباتی', 'B2', 'C1'), -- computational (formal)
  (208549, 'سیفون', 'B1', 'B2'), -- siphon / toilet flush (loanword)
  (208551, 'مَکر', 'B2', 'C1'), -- deceit / cunning (formal, literary)
  (208552, 'عُبوری', 'B2', 'C1'), -- transit / passing through (formal)
  (208553, 'نیوتُن', 'B2', 'C1'), -- newton [physics unit]
  (208554, 'مُتَقابِلاً', 'B1', 'C1'), -- mutually / reciprocally (formal)
  (208555, 'فَقیرانه', 'B2', 'C1'), -- poorly / in a poor manner (formal)
  (208556, 'گیجی', 'B1', 'B2'), -- confusion / dizziness (formal)
  (208557, 'زَعفَران', 'A1', 'A2'), -- saffron
  (208560, 'زیرَکانه', 'B2', 'C1'), -- shrewdly / cleverly (formal)
  (208561, 'تونیک', 'B2', 'C1'), -- tonic; tunic [dress] (loanword)
  (208562, 'تَقلیدی', 'B2', 'C1'), -- imitative (formal)
  (208563, 'موزاییک', 'B1', 'C1'), -- mosaic (formal, loanword)
  (208564, 'نارَس', 'B1', 'C1'), -- premature / unripe (formal)
  (208565, 'هَشت‌پا', 'A2', 'B1'), -- octopus
  (208566, 'تَثلیث', 'B2', 'C1'), -- Trinity (formal, religious)
  (208567, 'سَخت‌کوش', 'B2', 'C2'), -- hardworking / diligent (formal)
  (208568, 'خانداني', 'B2', 'C1'), -- dynastic / of a family lineage (formal)
  (208569, 'پاتیناژ', 'B1', 'C1'), -- ice skating (formal)
  (208570, 'باربَری', 'B1', 'B2'), -- freight / cargo transport (formal)
  (208571, 'نیازمَندی', 'B1', 'C1'), -- need / requirement (formal)
  (208572, 'تَأییدیه', 'B2', 'C1'), -- confirmation letter / certificate (formal)
  (208573, 'ناپایداری', 'B1', 'C1'), -- instability (formal)
  (208574, 'تِز', 'B1', 'B2'), -- thesis (loanword)
  (208575, 'طَبع', 'B1', 'B2'), -- nature / temperament (formal)
  (208576, 'خَرِفت', 'B2', 'C1'), -- senile / decrepit (formal)
  (208577, 'میانبُر', 'B1', 'B2'), -- shortcut (formal)
  (208578, 'اِمکان‌پَذیر', 'B1', 'C1'), -- feasible / possible (formal)
  (208579, 'یِکپارچگی', 'B1', 'B2'), -- integrity / unity (formal)
  (208580, 'قَرین', 'B2', 'C1'), -- companion / paired with (formal, literary)
  (208581, 'پوشال', 'B2', 'C2'), -- straw / packing material (formal)
  (208582, 'ناهَمتا', 'B2', 'C2'), -- unmatched / unparalleled (formal)
  (208583, 'نیلی', 'B1', 'C1'), -- indigo-colored (formal)
  (208584, 'سَم‌پاشی', 'B2', 'C2'), -- pesticide spraying (formal)
  (208585, 'حاصِله', 'B2', 'C2'), -- resulting / obtained (formal)
  (208586, 'گُذَرا', 'B2', 'C1'), -- brief / transient (formal)
  (208587, 'ضَجّه', 'B2', 'C2'), -- wail / moan (formal)
  (208588, 'ناآرام', 'B1', 'C1'), -- restless / turbulent (formal)
  (208589, 'یِک‌مَرتَبه', 'B1', 'C1'), -- suddenly / all at once (formal)
  (208590, 'اِنتِگرال', 'B2', 'C2'), -- integral [math] (loanword)
  (208591, 'دَرَخشیدَن', 'B1', 'B2'), -- to shine
  (208592, 'مِزاجی', 'B2', 'C1'), -- temperamental / constitutional (formal)
  (208593, 'لیتیوم', 'B1', 'B2'), -- lithium (loanword)
  (208594, 'فَرَج', 'B2', 'C2'), -- relief / deliverance (formal, religious)
  (208595, 'اتریشی', 'A2', 'B1'), -- Austrian (nationality)
  (208596, 'عِیار', 'B2', 'C1'), -- caliber / purity [gold] (formal)
  (208597, 'سَعد', 'B2', 'C2'), -- auspicious / fortunate (formal, literary)
  (208598, 'بَرکَناری', 'B2', 'C1'), -- dismissal / removal (formal, from office)
  (208599, 'پَرخاشگَری', 'B1', 'B2'), -- aggression / aggressiveness (formal)
  (208600, 'اِکوسیستِم', 'B1', 'C1'), -- ecosystem (loanword)
  (208601, 'بَربَر', 'B2', 'C1'), -- barbarian (formal)
  (208602, 'گَزنه', 'B2', 'C2'), -- nettle [plant] (formal)
  (208603, 'ساخارین', 'B2', 'C2'), -- saccharin (loanword)
  (208604, 'اِنفِعال', 'B2', 'C2'), -- passivity (formal)
  (208605, 'مُجَذَّر', 'B2', 'C1'), -- square [math] (formal)
  (208608, 'کِشکَک', 'B2', 'C1'), -- kneecap / patella (formal, medical)
  (208609, 'بازگردانی', 'B1', 'B2'), -- restoration / return (formal)
  (208610, 'اِجماع', 'B2', 'C2'), -- consensus (formal)
  (208611, 'کارکِشته', 'B2', 'C1'), -- experienced / seasoned (formal)
  (208613, 'بَقایا', 'B1', 'C1'), -- remains / relics (formal, plural of بقیه)
  (208614, 'روادید', 'B1', 'C1'), -- visa (formal)
  (208615, 'نَباتی', 'B1', 'C1'), -- vegetal / plant-based (formal)
  (208617, 'اِنعِکاسی', 'B1', 'C1'), -- reflective (formal)
  (208618, 'باایمان', 'B2', 'C2'), -- faithful / pious (formal)
  (208619, 'چَهارگوش', 'B2', 'C2'), -- quadrilateral / square-shaped (formal)
  (208620, 'جِناس', 'B2', 'C2'), -- pun / wordplay (formal, literary)
  (208622, 'ریمِل', 'A2', 'B1'), -- mascara (loanword)
  (208623, 'موشکافانه', 'B2', 'C2'), -- meticulously / scrutinizingly (formal)
  (208624, 'دیوانگان', 'B2', 'C1'), -- madmen (formal, plural of دیوانه)
  (208625, 'نئاندرتال', 'B2', 'C2'), -- Neanderthal (loanword)
  (208626, 'زیرین', 'B2', 'C1'), -- lower / nether (formal)
  (208627, 'مَجموعاً', 'B1', 'C1'), -- collectively / in total (formal)
  (208628, 'شتابزَده', 'B2', 'C2'), -- hasty / rash (formal)
  (208629, 'رژلَب', 'A2', 'B1'), -- lipstick
  (208630, 'دیافراگم', 'B2', 'C2'), -- diaphragm (formal, medical, loanword)
  (208631, 'فَقیرنِشین', 'B2', 'C1'), -- poor / impoverished [neighborhood] (formal)
  (208633, 'آبادی', 'B1', 'B2'), -- village / prosperity (formal)
  (208634, 'اِرتِجاعی', 'B2', 'C2'), -- reactionary (formal, political)
  (208635, 'مَرتَع', 'B2', 'C2'), -- pasture / rangeland (formal)
  (208636, 'کاهِنان', 'B2', 'C2'), -- priests (formal, plural of کاهن)
  (208637, 'آلومینیومی', 'B1', 'B2'), -- aluminum [adjective] (formal)
  (208638, 'چَرندیات', 'B1', 'B2'), -- nonsense (formal, plural)
  (208639, 'آوانس', 'B2', 'C2'), -- advance payment (formal, loanword)
  (208640, 'پیشگام', 'B1', 'B2'), -- pioneer (formal)
  (208641, 'کَشک', 'B1', 'C1'), -- kashk [dairy product] (formal)
  (208642, 'دَریادار', 'B2', 'C1'), -- admiral [military rank] (formal)
  (208643, 'هَمفِکر', 'B1', 'C1'), -- like-minded (formal)
  (208644, 'دیندار', 'B1', 'C1'), -- religious / pious (formal)
  (208645, 'اِرفاق', 'B2', 'C2'), -- leniency / favor (formal)
  (208647, 'اِلهیّات', 'B2', 'C1'), -- theology (formal)
  (208648, 'کِرخت', 'B2', 'C1'), -- numb / torpid (formal)
  (208649, 'سَربُلَندی', 'B1', 'B2'), -- success / honor / pride (formal)
  (208650, 'یِکتا', 'B2', 'C1'), -- unique / singular (formal, literary)
  (208651, 'مَصائِب', 'B2', 'C2'), -- sufferings / tribulations (formal, plural of مصیبت)
  (208652, 'پانکراس', 'B2', 'C2'), -- pancreas (medical, loanword)
  (208653, 'اِحتِکار', 'B2', 'C2'), -- hoarding (formal, economic)
  (208654, 'تَداخُلی', 'B2', 'C1'), -- interfering (formal)
  (208656, 'اُمیدوارکُننده', 'B1', 'C1'), -- encouraging / hopeful (formal)
  (208657, 'مَزار', 'B1', 'C1'), -- grave / shrine (formal)
  (208658, 'اِنقِراض', 'B1', 'B2'), -- extinction (formal)
  (208659, 'ناپِدَری', 'B1', 'B2'), -- stepfather (formal)
  (208660, 'ایثار', 'B2', 'C1'), -- self-sacrifice (formal)
  (208661, 'اَرج', 'B2', 'C2'), -- value / esteem (formal; ارج نهادن)
  (208662, 'کُشته', 'B1', 'A2'), -- killed / deceased (formal)
  (208663, 'تُندخو', 'B2', 'C2'), -- hot-tempered (formal)
  (208664, 'جادار', 'B1', 'C1'), -- spacious (formal)
  (208665, 'موّاج', 'B2', 'C2'), -- wavy / undulating (formal)
  (208666, 'وانیلی', 'A2', 'B1'), -- vanilla [adjective]
  (208667, 'اَفلیج', 'B2', 'C2'), -- paralyzed / crippled (formal)
  (208668, 'گِریان', 'B2', 'C1'), -- crying / weeping (formal)
  (208669, 'ضِمنی', 'B2', 'C1'), -- implicit (formal)
  (208670, 'قُلق', 'B1', 'B2'), -- knack / trick (formal)
  (208671, 'تیزهوشی', 'B2', 'C1'), -- sharp-wittedness / giftedness (formal)
  (208672, 'اَشرَف', 'B2', 'C2'), -- noblest (formal; اشرف مخلوقات)
  (208673, 'مُؤاخَذه', 'B2', 'C2'), -- reprimand / questioning (formal)
  (208674, 'ناهَموار', 'B1', 'B2'), -- uneven (formal)
  (208675, 'زورکی', 'B1', 'B2'), -- forced / coerced (formal)
  (208676, 'چَسبَندگی', 'B2', 'C1'), -- adhesiveness / stickiness (formal)
  (208677, 'مَقتولین', 'B2', 'C1'), -- victims / the murdered (formal, plural)
  (208678, 'فریبَندگی', 'B2', 'C1'), -- seductiveness / charm (formal)
  (208679, 'لوگو', 'A2', 'B1'), -- logo (loanword)
  (208680, 'فَراطَبیعی', 'B2', 'C1'), -- supernatural (formal)
  (208681, 'گَشتاوَر', 'B2', 'C2'), -- torque [physics] (formal)
  (208682, 'ناظِم', 'B1', 'C1'), -- supervisor / discipline officer [school] (formal)
  (208683, 'قِمارخانه', 'B1', 'C1'), -- gambling house (formal)
  (208684, 'نوظهور', 'B2', 'C2'), -- newly emerged / nascent (formal)
  (208685, 'پیکسِل', 'B1', 'C1'), -- pixel (loanword)
  (208686, 'اِهتِزاز', 'B2', 'C2'), -- fluttering / waving (formal; پرچم در اهتزاز)
  (208687, 'جَغجَغه', 'A2', 'B1'), -- rattle [baby toy]
  (208688, 'گُفتَمان', 'B1', 'C1'), -- discourse (formal)
  (208689, 'اِلتِهابی', 'B2', 'C2'), -- inflammatory (medical)
  (208691, 'اَدَوات', 'B2', 'C2'), -- instruments / tools (formal, plural of اداة)
  (208692, 'فَناناپَذیری', 'B2', 'C1'), -- immortality / indestructibility (formal)
  (208693, 'کَشفیّات', 'B2', 'C1'), -- discoveries (formal, plural)
  (208694, 'جالباسی', 'A2', 'B1'), -- coat rack / clothes hanger
  (208695, 'بَرخوردَن', 'B1', 'A2'), -- to collide / to encounter
  (208696, 'عایِد', 'B2', 'C2'), -- accruing / resulting (formal)
  (208697, 'باوَفا', 'B1', 'B2'), -- loyal (formal)
  (208698, 'بِهسازی', 'B2', 'C1'), -- improvement / upgrading (formal)
  (208700, 'قَدرشناسی', 'B1', 'C1'), -- gratitude / appreciation (formal)
  (208701, 'عارِف', 'B2', 'C2'), -- mystic (formal, religious)
  (208702, 'مُنفَصِل', 'B2', 'C2'), -- detached / separated (formal)
  (208704, 'ناکافی', 'B1', 'C1'), -- insufficient (formal)
  (208705, 'خوش‌رو', 'B1', 'C1'), -- cheerful / pleasant-faced (formal)
  (208706, 'اَرتِشبَد', 'B2', 'C1'), -- field marshal (formal, military rank)
  (208707, 'تَمثیل', 'B2', 'C2'), -- allegory (formal, literary)
  (208708, 'اِبتِذال', 'B2', 'C2'), -- vulgarity / banality (formal)
  (208709, 'مُنقَلِب', 'B2', 'C2'), -- agitated / upset (formal)
  (208711, 'نِفاق', 'B2', 'C2'), -- hypocrisy / discord (formal)
  (208713, 'فریبکار', 'B1', 'B2'), -- deceitful / con artist (formal)
  (208714, 'مؤَلِّفه', 'B2', 'C2'), -- component / factor (formal)
  (208715, 'سِتَمگَری', 'B2', 'C1'), -- tyranny / oppression (formal)
  (208716, 'اِطلاق', 'B2', 'C2'), -- designation / application (formal, term usage)
  (208717, 'تَصَنُّعی', 'B2', 'C2'), -- artificial / contrived (formal)
  (208718, 'نَصّاب', 'B2', 'C2'), -- installer (formal); quorum (formal)
  (208719, 'به‌راستی', 'B2', 'C1'), -- truly / indeed (formal)
  (208721, 'پُرافاده', 'B2', 'C2'), -- pretentious / affected (formal)
  (208722, 'قوسی', 'B2', 'C2'), -- arc-shaped / curved (formal)
  (208723, 'اِستروئید', 'B2', 'C1'), -- steroid (formal, loanword)
  (208724, 'غَلتَک', 'B2', 'C2'), -- roller [tool] (formal)
  (208725, 'قُماش', 'B2', 'C2'), -- fabric / cloth (formal)
  (208726, 'رویاپَرداز', 'B2', 'C1'), -- dreamer / visionary (formal)
  (208727, 'تیرخورده', 'B1', 'C1'), -- shot [by a bullet] (formal)
  (208728, 'آغازگَر', 'B2', 'C2'), -- initiator (formal)
  (208729, 'اِرادی', 'B2', 'C1'), -- voluntary / willful (formal)
  (208730, 'اَقاقیا', 'B2', 'C1'), -- acacia [tree] (formal)
  (208731, 'قَهّار', 'B2', 'C2'), -- dominant / powerful (formal, literary)
  (208732, 'مینیاتوری', 'B2', 'C1'), -- miniature [adjective] (formal)
  (208733, 'تولیدکُننده', 'B1', 'B2'), -- producer / manufacturer (formal)
  (208734, 'ضَخیم', 'A2', 'B1'), -- thick
  (208735, 'قَرینه', 'B2', 'C1'), -- symmetrical / counterpart (formal)
  (208736, 'بی‌مَزه', 'B1', 'C1'), -- tasteless / unfunny (formal)
  (208737, 'مُهاجِمین', 'B1', 'B2'), -- attackers / forwards (formal, plural)
  (208738, 'تُنُک', 'B2', 'C1'), -- sparse / thin (formal)
  (208739, 'تَظاهرکُننده', 'B1', 'C1'), -- protester (formal)
  (208740, 'مُخمَر', 'B2', 'C2'), -- yeast (formal)
  (208741, 'شوربا', 'B1', 'C1'), -- soup / broth [dish] (formal)
  (208742, 'گُلدوزی', 'B1', 'C1'), -- embroidery (formal)
  (208743, 'دیرینه', 'B2', 'C1'), -- ancient / longstanding (formal)
  (208745, 'باندپیچی', 'B1', 'C1'), -- bandaging (formal)
  (208746, 'موسوم', 'B2', 'C2'), -- known as / named (formal)
  (208747, 'قَدیر', 'B2', 'C1'), -- powerful / omnipotent (formal, religious)
  (208748, 'بُنیادین', 'B2', 'C1'), -- fundamental (formal)
  (208749, 'پُربَرَکَت', 'B2', 'C2'), -- blessed / abundant (formal)
  (208750, 'سوپِرقَهرَمان', 'A2', 'B1'), -- superhero
  (208751, 'آرتیست', 'B1', 'C1'), -- artist (formal, loanword)
  (208752, 'میانسالی', 'B1', 'C1'), -- middle age (formal)
  (208753, 'زَنبیل', 'A2', 'B1'), -- basket
  (208754, 'اِسکورت', 'B2', 'C1'), -- escort [security] (formal, loanword)
  (208755, 'ضَربدَری', 'B2', 'C1'), -- cross-shaped / X-marked (formal)
  (208756, 'سَربازگیری', 'B1', 'C1'), -- military recruitment (formal)
  (208757, 'رادون', 'B2', 'C2'), -- radon (formal, chemistry, loanword)
  (208758, 'دِلگَرمی', 'B1', 'B2'), -- reassurance (formal)
  (208759, 'شِنِوا', 'B1', 'C1'), -- hearing / able to hear (formal)
  (208760, 'مالیخولیایی', 'B2', 'C2'), -- melancholic (formal, literary)
  (208761, 'فُصول', 'B1', 'C1'), -- seasons / chapters (formal, plural of فصل)
  (208762, 'میادین', 'B1', 'C1'), -- squares (formal, plural of میدان)
  (208763, 'شُکوفایی', 'B1', 'B2'), -- blossoming / flourishing (formal)
  (208764, 'ناپیدا', 'B1', 'C1'), -- invisible / vanished (formal)
  (208765, 'پَکَر', 'B1', 'C1'), -- gloomy / downcast (formal)
  (208766, 'بیلچه', 'A2', 'B1'), -- small shovel / trowel
  (208767, 'پادویی', 'B2', 'C1'), -- errand-running / servant work (formal)
  (208768, 'فَنَری', 'B2', 'C1'), -- spring-loaded [adjective] (formal)
  (208769, 'اَنباشت', 'B2', 'C2'), -- accumulation (formal)
  (208770, 'نایلون', 'A2', 'B1'), -- nylon (loanword)
  (208771, 'نَظَریّات', 'B1', 'B2'), -- theories / opinions (formal, plural of نظریه)
  (208772, 'ژورنالیست', 'B1', 'C1'), -- journalist (loanword)
  (208774, 'حسابگَر', 'B2', 'C2'), -- calculating / shrewd (formal, figurative)
  (208775, 'خیانَتکار', 'B1', 'B2'), -- traitorous (formal)
  (208776, 'مُساوات', 'B2', 'C2'), -- equality (formal)
  (208777, 'مورَّب', 'B2', 'C2'), -- diagonal / slanted (formal)
  (208778, 'پَرهیزگار', 'B2', 'C1'), -- pious / abstinent (formal)
  (208780, 'صَریحاً', 'B1', 'B2'), -- explicitly / frankly (formal)
  (208781, 'آتِلیه', 'B1', 'C1'), -- studio [art/photo] (loanword)
  (208782, 'خَرکی', 'B1', 'B2'), -- brute-force / crude (formal-ish)
  (208783, 'تَخَیُّلات', 'B1', 'B2'), -- imaginations / fantasies (formal, plural)
  (208784, 'فَکور', 'B2', 'C2'), -- thoughtful / pensive (formal)
  (208785, 'ماندارین', 'A2', 'B1'), -- mandarin [orange; language] (loanword)
  (208786, 'ریال', 'A2', 'B1'), -- rial [currency]
  (208787, 'پوما', 'A2', 'B1'), -- puma (loanword)
  (208788, 'رامِن', 'A2', 'B1'), -- ramen (loanword)
  (208789, 'حریصانه', 'B2', 'C1'), -- greedily (formal)
  (208790, 'سَروتَه', 'B1', 'C1'), -- upside down / head-to-tail (formal-ish)
  (208791, 'مُبادِرَت', 'B2', 'C2'), -- undertaking / initiative (formal; مبادرت کردن)
  (208792, 'پُرکاری', 'B2', 'C1'), -- hyperactivity / diligence (formal; تیروئید پرکاری)
  (208793, 'بیلیونِر', 'B1', 'C1'), -- billionaire (loanword)
  (208794, 'گَلودَرد', 'A2', 'B1'), -- sore throat
  (208795, 'کَدوتَنبَل', 'A2', 'B1'), -- pumpkin / squash
  (208796, 'فرومایه', 'B2', 'C1'), -- base / despicable (formal, literary)
  (208797, 'نیکو', 'B2', 'C1'), -- good / nice (formal, literary)
  (208798, 'عُزلَت', 'B2', 'C2'), -- solitude / seclusion (formal, literary)
  (208799, 'اسپاسم', 'B2', 'C2'), -- spasm (medical, loanword)
  (208800, 'کُهولَت', 'B2', 'C2'), -- old age (formal)
  (208801, 'چُپُق', 'B2', 'C2'), -- pipe [smoking] (formal)
  (208802, 'دَرباری', 'B2', 'C1'), -- of the royal court (formal)
  (208803, 'اَوهام', 'B2', 'C2'), -- delusions / illusions (formal, plural of وهم)
  (208804, 'مَفاهیم', 'B1', 'B2'), -- concepts (formal, plural of مفهوم)
  (208805, 'قَدرشناس', 'B1', 'C1'), -- appreciative / grateful (formal)
  (208806, 'آبروریزی', 'B1', 'B2'), -- disgrace / scandal (formal)
  (208808, 'اِلزام', 'B1', 'C1'), -- obligation / requirement (formal)
  (208809, 'سَزا', 'B2', 'C2'), -- deserving / punishment (formal)
  (208811, 'اَخّاذ', 'B2', 'C2'), -- extortionist / blackmailer (formal)
  (208812, 'جارَختی', 'A2', 'B1'), -- coat rack
  (208813, 'آماس', 'B2', 'C2'), -- swelling / inflammation (formal, medical)
  (208814, 'بَصَری', 'B1', 'B2'), -- visual (formal)
  (208816, 'اَکیداً', 'B2', 'C1'), -- strictly (formal)
  (208817, 'نِشیب', 'B2', 'C1'), -- downward slope (formal)
  (208822, 'نَود', 'A1', 'A2'), -- ninety
  (208832, 'آن سویِ', 'B1', 'B2'), -- across / the other side of
  (208848, 'تَرسان', 'A1', 'A2'), -- afraid / scared
  (208864, 'هِجی کَردَن', 'A2', 'B1'), -- to spell
  (208878, 'پُلیوِر', 'A2', 'B1'), -- sweater
  (208887, 'موسیقی پاپ', 'B1', 'B2'), -- pop (music)
  (208889, 'سِه‌شَنبِه', 'A1', 'A2'), -- Tuesday
  (208892, 'خُطوطِ هَوایی', 'B1', 'B2'), -- airline
  (208898, 'مِعماری', 'B1', 'B2'), -- architecture
  (208905, 'لوبیا', 'A1', 'A2'), -- bean
  (208911, 'کَمپینگ', 'A2', 'B1'), -- camping
  (208913, 'سِلِبریتی', 'B1', 'C1'), -- celebrity
  (208932, 'فیلمبَرداری کَردَن', 'B1', 'B2'), -- to film
  (208935, 'آسیب رَساندَن', 'B1', 'C1'), -- to hurt
  (208942, 'پِلاستیک', 'A1', 'A2'), -- plastic
  (208945, 'بازیافت کَردَن', 'B1', 'B2'), -- to recycle
  (208947, 'مُرور کَردَن', 'B1', 'B2'), -- to review
  (208958, 'اِنشاء', 'A2', 'B1'), -- essay
  (208961, 'داستانِ تَخَیُّلی', 'A2', 'B1'), -- fiction
  (208962, 'تَناسُبِ اَندام داشتَن', 'A2', 'B1'), -- fit (in good shape)
  (208971, 'پُرسَر و صِدا', 'A2', 'B1'), -- noisy
  (208974, 'سازماندِهی کَردَن', 'B1', 'B2'), -- to organise
  (208980, 'دوشاخِه', 'A2', 'B1'), -- plug
  (208986, 'میخانه', 'B1', 'B2'), -- pub
  (208987, 'راه‌آهَن', 'A2', 'B2'), -- railway
  (208988, 'واکُنِش نِشان دادَن', 'B1', 'B2'), -- to react
  (209001, 'تَوسِعه دادَن', 'B1', 'B2'), -- to develop
  (209004, 'بِه اِشتِراک گُذاشتَن', 'A2', 'B1'), -- to share
  (209012, 'دَست تِکان دادَن', 'A2', 'B1'), -- to wave
  (209016, 'تَعادُل داشتَن', 'B1', 'B2'), -- to balance
  (209020, 'مَسدود کَردَن', 'B1', 'B2'), -- to block
  (209021, 'بُمباران کَردَن', 'B1', 'B2'), -- to bomb
  (209022, 'بِه چالِش کِشیدَن', 'B1', 'B2'), -- to challenge
  (209036, 'کُت‌شَلوار', 'A2', 'B2'), -- suit
  (209040, 'نوجَوانی', 'A2', 'B1'), -- teenage
  (209062, 'اَز عُهدِه‌ی هَزینه‌اش بَرآمَدَن', 'B1', 'C1'), -- to afford
  (209064, 'هَدَف', 'B1', 'A2'), -- aim / goal
  (209067, 'شِگِفت‌زَده', 'B1', 'C1'), -- amazed
  (209068, 'بلندپَرواز', 'B1', 'C1'), -- ambitious
  (209071, 'آزار دِهَنده', 'B1', 'B2'), -- annoying
  (209073, 'قَدردانی کَردَن', 'B1', 'B2'), -- to appreciate
  (209075, 'کُمَک کَردَن', 'B1', 'A2'), -- to assist
  (209076, 'ضَمیمه کَردَن', 'B1', 'B2'), -- to attach
  (209079, 'رَفتار', 'B1', 'A2'), -- behaviour
  (209083, 'پَردیس', 'B1', 'C1'), -- campus
  (209084, 'کُلاهِ لِبه‌دار', 'B1', 'B2'), -- cap
  (209087, 'تَقَلُّب کَردَن', 'B1', 'B2'), -- to cheat
  (209088, 'زُغال‌سَنگ', 'B1', 'C1'), -- coal
  (209098, 'حومِه', 'B1', 'B2'), -- countryside
  (209100, 'دِسکتاپ', 'B1', 'C1'), -- desktop
  (209104, 'سَررَسید', 'B1', 'C1'), -- due
  (209108, 'بِه‌طورِ مُؤَثِّر', 'B1', 'C1'), -- effectively
  (209113, 'بِه‌طورِ مُساوی', 'B1', 'B2'), -- equally
  (209118, 'اَکسپِدیشِن', 'B1', 'C1'), -- expedition
  (209119, 'دَریانَوَردی کَردَن', 'B1', 'B2'), -- to sail
  (209121, 'قایِقرانی', 'B1', 'B2'), -- sailing
  (209122, 'مُواجِه شُدَن با', 'B1', 'B2'), -- to face / to confront
  (209124, 'فارِغُ‌التَّحصیل شُدَن', 'B1', 'B2'), -- to graduate
  (209125, 'میزبانی کَردَن', 'B1', 'B2'), -- to host
  (209128, 'کَم داشتَن', 'B1', 'A2'), -- to lack
  (209138, 'سیلی زَدَن', 'B1', 'B2'), -- to slap
  (209143, 'کاوِش کَردَن', 'B1', 'B2'), -- to explore
  (209144, 'صادِرات', 'B1', 'B2'), -- export
  (209150, 'بَستَن', 'B1', 'A2'), -- to fasten
  (209153, 'فِلاش', 'B1', 'B2'), -- flash
  (209154, 'مَردُم', 'B1', 'A2'), -- folk / people
  (209155, 'بَرای هَمیشه', 'B1', 'A2'), -- forever
  (209157, 'مُکَرَّراً', 'B1', 'B2'), -- frequently
  (209162, 'خَز', 'B1', 'B2'), -- fur
  (209163, 'بیشتَر', 'B1', 'A2'), -- further
  (209165, 'آقا', 'B1', 'A2'), -- gentleman
  (209166, 'کُنسِرت کوچَک', 'B1', 'B2'), -- gig
  (209167, 'خوشحال', 'B1', 'A2'), -- glad
  (209170, 'آویزان کَردَن', 'B1', 'B2'), -- to hang
  (209172, 'بِه‌شِدَّت', 'B1', 'C1'), -- heavily
  (209173, 'بَرجَسته کَردَن', 'B1', 'B2'), -- to highlight
  (209174, 'بِه‌شِدَّت', 'B1', 'C1'), -- highly
  (209180, 'گِردباد', 'B1', 'B2'), -- hurricane
  (209187, 'چِشمگیر', 'B1', 'B2'), -- impressive
  (209189, 'بِه‌طورِ باوَرنَکَردَنی', 'B1', 'B2'), -- incredibly
  (209190, 'سَرپوشیده', 'B1', 'C1'), -- indoor
  (209191, 'در فَضایِ سَرپوشیده', 'B1', 'C1'), -- indoors
  (209196, 'فَناوَریِ اِطِّلاعات', 'B1', 'B2'), -- IT (information technology)
  (209198, 'قَتل', 'B1', 'A2'), -- killing
  (209200, 'بَرچَسب زَدَن', 'B1', 'B2'), -- to label
  (209201, 'آخَرین', 'B1', 'A2'), -- latest
  (209202, 'گُذاشتَن', 'B1', 'A2'), -- to lay
  (209204, 'زِندِگی کَردَن', 'B1', 'A2'), -- living
  (209205, 'زِنده', 'B1', 'A2'), -- living
  (209208, 'تَنها', 'B1', 'A2'), -- lonely
  (209209, 'تَجَمُّل', 'B1', 'C1'), -- luxury
  (209210, 'بازاریابی', 'B1', 'B2'), -- marketing
  (209211, 'در هَمین حال', 'B1', 'A2'), -- meanwhile
  (209213, 'آسیاب', 'B1', 'B2'), -- mill
  (209215, 'نَه ... نَه', 'B1', 'A2'), -- nor
  (209217, 'هَسته‌ای', 'B1', 'C1'), -- nuclear
  (209218, 'بَدیهی اَست کِه', 'B1', 'C1'), -- obviously
  (209222, 'بَرگُزارکُننده', 'B1', 'C1'), -- organiser
  (209223, 'بایَد', 'B1', 'A2'), -- ought to
  (209224, 'در فَضایِ باز', 'B1', 'B2'), -- outdoors
  (209225, 'بالِشتَک', 'B1', 'C1'), -- pad
  (209229, 'کامِلاً', 'B1', 'A2'), -- perfectly
  (209230, 'بَدبین', 'B1', 'B2'), -- pessimistic
  (209232, 'فَراوان', 'B1', 'B2'), -- plenty
  (209233, 'بِه‌عِلاوِه', 'B1', 'C1'), -- plus
  (209235, 'اِحتِمالاً', 'B1', 'A2'), -- possibly
  (209237, 'واجِدِ شَرایِط', 'B1', 'C1'), -- qualified
  (209238, 'واجِدِ شَرایِط شُدَن', 'B1', 'C1'), -- to qualify
  (209241, 'نَقلِ‌قول کَردَن', 'B1', 'B2'), -- to quote
  (209242, 'مُسابِقه‌یِ اتومبیل‌رانی', 'B1', 'B2'), -- racing
  (209243, 'مُنعَکِس کَردَن', 'B1', 'B2'), -- to reflect
  (209246, 'آرامش‌بَخش', 'B1', 'C1'), -- relaxing
  (209248, 'نُمایِندگی کَردَن', 'B1', 'B2'), -- to represent
  (209251, 'بازنِشَسته شُدَن', 'B1', 'B2'), -- to retire
  (209254, 'غَلتیدَن', 'B1', 'C1'), -- to roll
  (209255, 'راگبی', 'B1', 'B2'), -- rugby
  (209256, 'فیلمنامه', 'B1', 'B2'), -- script
  (209257, 'جِدّاً', 'B1', 'A2'), -- seriously
  (209259, 'جِنسیَّت', 'B1', 'B2'), -- sex (gender)
  (209267, 'مُحکَم بَستَن', 'B1', 'B2'), -- to slam
  (209269, 'بُریدَن', 'B1', 'A2'), -- to slice
  (209270, 'کَمی', 'B1', 'A2'), -- slightly
  (209272, 'هَرزنامه', 'B1', 'C1'), -- spam
  (209275, 'گُفتاری', 'B1', 'C1'), -- spoken
  (209280, 'حَتماً', 'B1', 'A2'), -- surely
  (209281, 'زِنده ماندَن', 'B1', 'A2'), -- to survive
  (209287, 'تَمایُل داشتَن', 'B1', 'B2'), -- to tend
  (209289, 'با این حال', 'B1', 'A2'), -- though
  (209290, 'کاملاً', 'B1', 'A2'), -- totally
  (209295, 'ناتَوان', 'B1', 'B2'), -- unable
  (209300, 'ناخوشایَند', 'B1', 'B2'), -- unpleasant
  (209306, 'هَر چه', 'B1', 'A2'), -- whatever
  (209308, 'داد زَدَن', 'B1', 'A2'), -- to yell
  (209309, 'جَذب کَردَن', 'B2', 'C1'), -- to absorb
  (209311, 'اَز رویِ تَصادُف', 'B2', 'C1'), -- accidentally
  (209313, 'هَمراهی کَردَن', 'B2', 'C1'), -- to accompany
  (209314, 'اَنجام دادَن (کامِل)', 'B2', 'C1'), -- to accomplish
  (209315, 'توضیح دادَنِ عِلَّتِ', 'B2', 'C1'), -- to account for
  (209317, 'بِه‌طورِ دَقیق', 'B2', 'C1'), -- accurately
  (209319, 'بِه رَسمیَّت شِناختَن', 'B2', 'C1'), -- to acknowledge
  (209320, 'اِیکِر', 'B2', 'C2'), -- acre
  (209322, 'سازگار شُدَن', 'B2', 'C1'), -- to adapt
  (209323, 'عِلاوِه بَر این', 'B2', 'C1'), -- additionally
  (209326, 'بِه فَرزَندی گِرِفتَن', 'B2', 'C1'), -- to adopt
  (209328, 'مُقرون‌بِه‌صَرفه', 'B2', 'C1'), -- affordable
  (209331, 'بیگانه', 'B2', 'C1'), -- alien
  (209333, 'رویِ‌هَم‌رَفتِه', 'B2', 'C2'), -- altogether
  (209334, 'سَرگَرم‌کُننده', 'B2', 'C2'), -- amusing
  (209335, 'تَحلیل کَردَن', 'B2', 'C1'), -- to analyse
  (209337, 'بِه‌طورِ مُناسِب', 'B2', 'C1'), -- appropriately
  (209342, 'اَثَرِ هُنَری', 'B2', 'C1'), -- artwork
  (209343, 'اَرزیابی کَردَن', 'B2', 'C1'), -- to assess
  (209344, 'واگُذار کَردَن', 'B2', 'C1'), -- to assign
  (209345, 'مُرتَبِط', 'B2', 'C1'), -- associated
  (209347, 'حَیرَت‌اَنگیز', 'B2', 'C1'), -- astonishing
  (209348, 'آگاهی', 'B2', 'C1'), -- awareness
  (209349, 'ناجور', 'B2', 'C1'), -- awkward
  (209351, 'باله', 'B2', 'C1'), -- ballet
  (209352, 'بِه‌سَختی', 'B2', 'C1'), -- barely
  (209354, 'التِماس کَردَن', 'B2', 'C1'), -- to beg
  (209356, 'شَرط بَستَن', 'B2', 'C1'), -- to bet
  (209357, 'تَعَصُّب', 'B2', 'C1'), -- bias
  (209358, 'پیشنَهادِ قیمَت دادَن', 'B2', 'C1'), -- to bid
  (209359, 'پَیوَند', 'B2', 'C1'), -- bond
  (209360, 'تَقویَت کَردَن', 'B2', 'C1'), -- to boost
  (209362, 'بِه‌طورِ خُلاصه', 'B2', 'C1'), -- briefly
  (209364, 'مُجریِ پَخش', 'B2', 'C1'), -- broadcaster
  (209367, 'باگ', 'B2', 'C1'), -- bug (software)
  (209369, 'مُحاسِبه کَردَن', 'B2', 'C1'), -- to calculate
  (209370, 'لَغو کَردَن', 'B2', 'C1'), -- to cancel
  (209371, 'بِه‌دام اَنداختَن', 'B2', 'C1'), -- to capture
  (209372, 'رَسمی نَبودَن', 'B2', 'C1'), -- casual
  (209376, 'تِشویق کَردَن', 'B2', 'C1'), -- to cheer
  (209379, 'اِستِناد کَردَن', 'B2', 'C1'), -- to cite
  (209380, 'بَند (حُقوقی)', 'B2', 'C1'), -- clause
  (209383, 'کُلِکسیونِر', 'B2', 'C1'), -- collector
  (209384, 'رَنگارَنگ', 'B2', 'C1'), -- colourful
  (209385, 'خَنده‌دار', 'B2', 'C1'), -- comic
  (209387, 'مُقایِسه‌ای', 'B2', 'C1'), -- comparative
  (209388, 'ساختَن (موسیقی)', 'B2', 'C1'), -- to compose
  (209392, 'گیج‌کُننده', 'B2', 'C1'), -- confusing
  (209395, 'مُحافِظه‌کار', 'B2', 'C1'), -- conservative
  (209396, 'قابِلِ‌توجُّه', 'B2', 'C1'), -- considerable
  (209398, 'تَشکیل شُدَن اَز', 'B2', 'C1'), -- to consist of
  (209401, 'مَصرَف‌کُننده', 'B2', 'C1'), -- consumer
  (209404, 'کُمَک کَردَن (مالی/فِکری)', 'B2', 'C1'), -- to contribute
  (209410, 'شَرکَتی', 'B2', 'C1'), -- corporate
  (209412, 'شَهرِستان', 'B2', 'C1'), -- county
  (209413, 'پوشِش خَبَری', 'B2', 'C1'), -- coverage
  (209415, 'بِه‌طورِ اِنتِقادی', 'B2', 'C2'), -- critically
  (209416, 'اِنتِقاد کَردَن', 'B2', 'C1'), -- to criticise
  (209418, 'اِشارِه (نِمایِشی)', 'B2', 'C1'), -- cue
  (209419, 'بَرنامه‌یِ دَرسی', 'B2', 'C1'), -- curriculum
  (209420, 'لَبَنیّات', 'B2', 'C1'), -- dairy
  (209422, 'پایگاهِ داده', 'B2', 'C1'), -- database
  (209426, 'عَمداً', 'B2', 'C1'), -- deliberately
  (209429, 'اِنکار کَردَن', 'B2', 'C1'), -- to deny
  (209430, 'عَزیمَت کَردَن', 'B2', 'C1'), -- to depart
  (209431, 'اَفسُرده‌کُننده', 'B2', 'C1'), -- depressing
  (209432, 'گِرِفتَن (اَز مَنبَعی)', 'B2', 'C1'), -- to derive
  (209433, 'بِه‌شِدَّت نیازمَند', 'B2', 'C1'), -- desperately
  (209435, 'وَقف کَردَن', 'B2', 'C1'), -- to devote
  (209437, 'ده‌سِنتی', 'B2', 'C1'), -- dime
  (209438, 'اِختِلافِ‌نَظَر', 'B2', 'C1'), -- disagreement
  (209439, 'ناامید کَردَن', 'B2', 'C1'), -- to disappoint
  (209440, 'ناامیدی', 'B2', 'C1'), -- disappointment
  (209441, 'دیسک', 'B2', 'C1'), -- disc
  (209442, 'دِلسَرد کَردَن', 'B2', 'C1'), -- to discourage
  (209443, 'نادُرُست (غَیرِصادِق)', 'B2', 'C1'), -- dishonest
  (209445, 'تَشخیص دادَن (فَرق)', 'B2', 'C1'), -- to distinguish
  (209446, 'حَواس‌پَرت کَردَن', 'B2', 'C1'), -- to distract
  (209447, 'توزیع کَردَن', 'B2', 'C1'), -- to distribute
  (209449, 'تَسَلُّط داشتَن', 'B2', 'C1'), -- to dominate
  (209451, 'پیش‌نَویس', 'B2', 'C2'), -- draft
  (209452, 'بِه‌طورِ چِشمگیر', 'B2', 'C2'), -- dramatically
  (209453, 'کِسِل‌کُننده', 'B2', 'C1'), -- dull
  (209455, 'اِقتِصاد (عِلم)', 'B2', 'C1'), -- economics
  (209456, 'اِقتِصاددان', 'B2', 'C2'), -- economist
  (209457, 'ویرایِش کَردَن', 'B2', 'C1'), -- to edit
  (209458, 'چاپ (نَشر)', 'B2', 'C1'), -- edition
  (209459, 'بِه‌طورِ کارآمَد', 'B2', 'C2'), -- efficiently
  (209460, 'اِنتِخاب کَردَن (رَأی)', 'B2', 'C1'), -- to elect
  (209461, 'اِلِکترونیک', 'B2', 'C1'), -- electronics
  (209462, 'شیک', 'B2', 'C1'), -- elegant
  (209464, 'ظاهِر شُدَن', 'B2', 'C1'), -- to emerge
  (209465, 'اِنتِشار (گاز)', 'B2', 'C1'), -- emission
  (209466, 'اَز نَظَرِ عاطِفی', 'B2', 'C1'), -- emotionally
  (209467, 'تأکید کَردَن', 'B2', 'C1'), -- to emphasise
  (209468, 'اِمپراتوری', 'B2', 'C1'), -- empire
  (209469, 'اِمکان‌پَذیر کَردَن', 'B2', 'C1'), -- to enable
  (209471, 'اَرتِقا دادَن', 'B2', 'C1'), -- to enhance
  (209472, 'اِستِعلام', 'B2', 'C2'), -- enquiry
  (209473, 'اَطمینان حاصِل کَردَن', 'B2', 'C1'), -- to ensure
  (209474, 'سَرگَرم‌کُننده', 'B2', 'C2'), -- entertaining
  (209476, 'کارآفرین', 'B2', 'C2'), -- entrepreneur
  (209477, 'پاکَت‌نامه', 'B2', 'C1'), -- envelope
  (209478, 'تَجهیز کَردَن', 'B2', 'C1'), -- to equip
  (209479, 'فَوَران کَردَن', 'B2', 'C1'), -- to erupt
  (209480, 'اَساساً', 'B2', 'C1'), -- essentially
  (209481, 'اَخلاق', 'B2', 'C1'), -- ethic
  (209482, 'اَخلاقی', 'B2', 'C1'), -- ethical
  (209483, 'اَرزیابی کَردَن', 'B2', 'C1'), -- to evaluate
  (209485, 'تَکامُل یافتَن', 'B2', 'C1'), -- to evolve
  (209486, 'اَز حَد گُذَشتَن', 'B2', 'C1'), -- to exceed
  (209488, 'مُستَثنا کَردَن', 'B2', 'C2'), -- to exclude
  (209489, 'مَدیرِ اَرشَد', 'B2', 'C1'), -- executive
  (209490, 'اِگزوتیک', 'B2', 'C1'), -- exotic
  (209491, 'بهره‌کِشی کَردَن', 'B2', 'C1'), -- to exploit
  (209492, 'در مُعَرِض قِرار دادَن', 'B2', 'C1'), -- to expose
  (209493, 'بِه‌طورِ گُستَرده', 'B2', 'C1'), -- extensively
  (209494, 'فوق‌العاده', 'B2', 'C1'), -- fabulous
  (209495, 'اِمکانات', 'B2', 'C1'), -- facility
  (209496, 'خیال‌پَردازی', 'B2', 'C1'), -- fantasy
  (209498, 'اُمورِ مالی', 'B2', 'C1'), -- finance
  (209499, 'آتِش‌بازی', 'B2', 'C2'), -- firework
  (209500, 'بِه‌طورِ محکَم', 'B2', 'C1'), -- firmly
  (209501, 'طَعم', 'B2', 'C1'), -- flavour
  (209502, 'شِناوَر بودَن', 'B2', 'C1'), -- to float
  (209503, 'تاشو', 'B2', 'C1'), -- folding
  (209504, 'عَلاقه‌مَند', 'B2', 'C2'), -- fond
  (209506, 'مَمنوع کَردَن (رَسمی)', 'B2', 'C1'), -- to forbid
  (209507, 'پیش‌تَر', 'B2', 'C1'), -- formerly
  (209510, 'مُکَرَّر', 'B2', 'C1'), -- frequent
  (209511, 'بَرآوَردِه کَردَن', 'B2', 'C1'), -- to fulfil
  (209513, 'بودجه', 'B2', 'C1'), -- funding
  (209514, 'عِلاوِه‌بَراین', 'B2', 'C1'), -- furthermore
  (209515, 'بازی‌هایِ رایانه‌ای', 'B2', 'C1'), -- gaming
  (209516, 'هَمجِنسگَرا', 'B2', 'C1'), -- gay
  (209520, 'جَهانی‌شُدَن', 'B2', 'C1'), -- globalization
  (209521, 'کُرِه‌یِ زَمین', 'B2', 'C1'), -- globe
  (209523, 'خیره‌کُننده', 'B2', 'C1'), -- gorgeous
  (209524, 'باشُکوه', 'B2', 'C1'), -- grand
  (209525, 'کُمَکِ مالی', 'B2', 'C1'), -- grant
  (209526, 'بِه‌شِدَّت', 'B2', 'C2'), -- greatly
  (209527, 'دَستورُالعَمَل', 'B2', 'C1'), -- guideline
  (209528, 'زیستگاه', 'B2', 'C1'), -- habitat
  (209529, 'بَندَرگاه', 'B2', 'C1'), -- harbour
  (209530, 'بِهبود یافتَن', 'B2', 'C1'), -- to heal
  (209531, 'مُراقِبَتِ بِهداشتی', 'B2', 'C1'), -- healthcare
  (209533, 'گیاهِ دارویی', 'B2', 'C1'), -- herb
  (209534, 'تَرَدُّد کَردَن', 'B2', 'C2'), -- to hesitate
  (209536, 'اُمیدوارانه', 'B2', 'C1'), -- hopefully
  (209537, 'خانِوار', 'B2', 'C2'), -- household
  (209538, 'مَسکَن', 'B2', 'C1'), -- housing
  (209539, 'کارتِ شناسایی', 'B2', 'C1'), -- ID
  (209540, 'با تَصویر نِشان دادَن', 'B2', 'C1'), -- to illustrate
  (209541, 'تَصویرسازی', 'B2', 'C2'), -- illustration
  (209542, 'ایمِن', 'B2', 'C1'), -- immune
  (209544, 'پیامَد', 'B2', 'C1'), -- implication
  (209545, 'دَلالَت داشتَن', 'B2', 'C1'), -- to imply
  (209546, 'تَحمیل کَردَن', 'B2', 'C1'), -- to impose
  (209547, 'تَحتِ‌تأثیر قِرار دادَن', 'B2', 'C1'), -- to impress
  (209548, 'تَحتِ‌تأثیر', 'B2', 'C1'), -- impressed
  (209549, 'گُنجاندَن', 'B2', 'C2'), -- to incorporate
  (209550, 'بِه‌طورِ فَزایَنده', 'B2', 'C2'), -- increasingly
  (209551, 'اَجتِناب‌ناپَذیر', 'B2', 'C1'), -- inevitably
  (209552, 'اِستِنباط کَردَن', 'B2', 'C1'), -- to infer
  (209553, 'تَوَرُّم', 'B2', 'C1'), -- inflation
  (209555, 'ساکِن', 'B2', 'C1'), -- inhabitant
  (209556, 'بِه اِرث بُردَن', 'B2', 'C1'), -- to inherit
  (209557, 'در اِبتِدا', 'B2', 'C1'), -- initially
  (209558, 'وارِد کَردَن (اِدراج)', 'B2', 'C1'), -- to insert
  (209559, 'اِصرار کَردَن', 'B2', 'C1'), -- to insist
  (209560, 'اِلهام بَخشیدَن', 'B2', 'C1'), -- to inspire
  (209561, 'یَکپارچه کَردَن', 'B2', 'C1'), -- to integrate
  (209562, 'تَعامُل داشتَن', 'B2', 'C2'), -- to interact
  (209563, 'تَعامُل', 'B2', 'C1'), -- interaction
  (209564, 'تَفسیر کَردَن', 'B2', 'C1'), -- to interpret
  (209567, 'حَمله کَردَن (نِظامی)', 'B2', 'C1'), -- to invade
  (209568, 'سَرمایه‌گُذاری', 'B2', 'C1'), -- investment
  (209569, 'سَرمایه‌گُذار', 'B2', 'C1'), -- investor
  (209570, 'مُنزَوی کَردَن', 'B2', 'C1'), -- to isolate
  (209571, 'زِندان (کوچَک)', 'B2', 'C1'), -- jail
  (209572, 'مَفصَل', 'B2', 'C1'), -- joint
  (209574, 'جوان‌تَر (رُتبه)', 'B2', 'C1'), -- junior
  (209575, 'هیئَتِ‌مُنصِفه', 'B2', 'C1'), -- jury
  (209576, 'توجیه کَردَن', 'B2', 'C1'), -- to justify
  (209577, 'کُلیه', 'B2', 'C1'), -- kidney
  (209578, 'کیفِ‌لَوازِم', 'B2', 'C1'), -- kit
  (209580, 'مَنظَره', 'B2', 'C1'), -- landscape
  (209581, 'خط (خیابان)', 'B2', 'C1'), -- lane
  (209582, 'بِه‌طورِ عُمده', 'B2', 'C1'), -- largely
  (209584, 'لیگ', 'B2', 'C1'), -- league
  (209585, 'تِکیه دادَن', 'B2', 'C1'), -- to lean
  (209587, 'طولِ عُمر', 'B2', 'C1'), -- lifetime
  (209588, 'بِه‌مَعنایِ واقِعی', 'B2', 'C1'), -- literally
  (209589, 'زُباله (پِراکَنده)', 'B2', 'C1'), -- litter
  (209590, 'بار (وَزن)', 'B2', 'C1'), -- load
  (209591, 'مَتنِ آهَنگ', 'B2', 'C1'), -- lyric
  (209592, 'تولید کَردَن (کارخانه)', 'B2', 'C1'), -- to manufacture
  (209593, 'ماژیک', 'B2', 'C1'), -- marker
  (209594, 'عَظیم', 'B2', 'C1'), -- massive
  (209596, 'مَکانیکی', 'B2', 'C1'), -- mechanical
  (209598, 'بِه‌یادماندَنی', 'B2', 'C1'), -- memorable
  (209599, 'مادِّه‌یِ مَعدَنی', 'B2', 'C1'), -- mineral
  (209601, 'اِشتِباه‌کُنَنده', 'B2', 'C1'), -- mistaken
  (209603, 'اِصلاح کَردَن', 'B2', 'C1'), -- to modify
  (209604, 'بَنایِ یادبود', 'B2', 'C1'), -- monument
  (209606, 'رَهن', 'B2', 'C1'), -- mortgage
  (209607, 'پَشه', 'B2', 'C1'), -- mosquito
  (209610, 'نَصب کَردَن', 'B2', 'C1'), -- to mount
  (209611, 'ضَرب کَردَن', 'B2', 'C1'), -- to multiply
  (209612, 'مُرَتَّب و تَمیز', 'B2', 'C1'), -- neat
  (209613, 'مُذاکِره کَردَن', 'B2', 'C1'), -- to negotiate
  (209614, 'دِلتَنگی برایِ گُذشته', 'B2', 'C2'), -- nostalgia
  (209616, 'رُمان‌نویس', 'B2', 'C1'), -- novelist
  (209617, 'پَرَستاری', 'B2', 'C1'), -- nursing
  (209618, 'چاقیِ مُفرِط', 'B2', 'C2'), -- obesity
  (209619, 'اِطاعَت کَردَن', 'B2', 'C1'), -- to obey
  (209621, 'اِشغال کَردَن', 'B2', 'C1'), -- to occupy
  (209622, 'جُرم (تَخَلُّف)', 'B2', 'C1'), -- offence
  (209623, 'رَنجاندَن', 'B2', 'C2'), -- to offend
  (209625, 'اُپِرا', 'B2', 'C1'), -- opera
  (209626, 'عَمَل کَردَن (دَستگاه)', 'B2', 'C1'), -- to operate
  (209627, 'مُخالِف', 'B2', 'C1'), -- opposed
  (209628, 'نوری (چَشمی)', 'B2', 'C1'), -- optical
  (209629, 'بیرونی', 'B2', 'C1'), -- outer
  (209631, 'طَرحِ کُلّی', 'B2', 'C1'), -- outline
  (209632, 'بَرجَسته', 'B2', 'C1'), -- outstanding
  (209633, 'غَلَبه کَردَن', 'B2', 'C1'), -- to overcome
  (209634, 'یِک‌شَبه', 'B2', 'C2'), -- overnight
  (209636, 'بِدَهکار بودَن', 'B2', 'C1'), -- to owe
  (209638, 'بَستِه (کوچَک)', 'B2', 'C1'), -- packet
  (209639, 'کَفِ دَست', 'B2', 'C1'), -- palm
  (209640, 'پارِه‌وَقت', 'B2', 'C1'), -- part-time
  (209641, 'شِرکَت‌کُنَنده', 'B2', 'C1'), -- participant
  (209642, 'تاحُدودی', 'B2', 'C2'), -- partly
  (209643, 'وَصله', 'B2', 'C1'), -- patch
  (209644, 'هَمتا', 'B2', 'C1'), -- peer
  (209646, 'بِه‌طورِ دائِم', 'B2', 'C1'), -- permanently
  (209648, 'نوک‌تیز', 'B2', 'C1'), -- pointed
  (209649, 'مَحبوبیَّت', 'B2', 'C1'), -- popularity
  (209650, 'ژِست', 'B2', 'C1'), -- pose
  (209651, 'مالِک بودَن', 'B2', 'C1'), -- to possess
  (209652, 'بِه‌طورِ بالقُوّه', 'B2', 'C1'), -- potentially
  (209653, 'قابِلِ‌پیش‌بینی', 'B2', 'C1'), -- predictable
  (209655, 'ریاست‌جُمهوری', 'B2', 'C1'), -- presidential
  (209656, 'عَمدَتاً', 'B2', 'C1'), -- primarily
  (209657, 'اَصلی (دَرَجه‌یَک)', 'B2', 'C1'), -- prime
  (209658, 'اَصلی (مُهِم‌تَرین)', 'B2', 'C1'), -- principal
  (209659, 'حَریمِ خُصوصی', 'B2', 'C1'), -- privacy
  (209662, 'بَرنامه‌نویسی', 'B2', 'C1'), -- programming
  (209663, 'اُمیدبَخش', 'B2', 'C1'), -- promising
  (209664, 'تِرغیب کَردَن', 'B2', 'C1'), -- to prompt
  (209665, 'شوخ‌طَبعی', 'B2', 'C1'), -- humour
  (209667, 'تَبلیغات (رَسانه‌ای)', 'B2', 'C1'), -- publicity
  (209668, 'پانک', 'B2', 'C1'), -- punk
  (209669, 'صِرفاً', 'B2', 'C1'), -- purely
  (209670, 'دُنبال کَردَن (هَدَف)', 'B2', 'C1'), -- to pursue
  (209671, 'پازِل', 'B2', 'C1'), -- puzzle
  (209672, 'نِژادی', 'B2', 'C1'), -- racial
  (209673, 'رادار', 'B2', 'C1'), -- radar
  (209674, 'ریل', 'B2', 'C1'), -- rail
  (209677, 'بِه‌سُرعَت', 'B2', 'C1'), -- rapidly
  (209678, 'واقِع‌بینانه', 'B2', 'C2'), -- realistic
  (209679, 'بِه‌طورِ مَعقول', 'B2', 'C1'), -- reasonably
  (209680, 'بازسازی کَردَن', 'B2', 'C1'), -- to rebuild
  (209681, 'رُکودِ اِقتِصادی', 'B2', 'C2'), -- recession
  (209682, 'گُمان کَردَن', 'B2', 'C1'), -- to reckon
  (209683, 'بِه‌رَسمیَّت‌شِناختَن', 'B2', 'C1'), -- recognition
  (209684, 'بِهبود یافتَن', 'B2', 'C1'), -- to recover
  (209685, 'اِستِخدام کَردَن (نیرو)', 'B2', 'C1'), -- to recruit
  (209686, 'مِنطَقه‌ای', 'B2', 'C1'), -- regional
  (209687, 'تَنظیم کَردَن (قانونی)', 'B2', 'C1'), -- to regulate
  (209688, 'مُقَرَّرات', 'B2', 'C1'), -- regulation
  (209689, 'نِسبَتاً', 'B2', 'C1'), -- relatively
  (209690, 'تَسکین دادَن', 'B2', 'C1'), -- to relieve
  (209691, 'آسوده‌خاطِر', 'B2', 'C1'), -- relieved
  (209692, 'تِکیه کَردَن بِه', 'B2', 'C1'), -- to rely on
  (209693, 'اِظهارِنَظَر', 'B2', 'C2'), -- remark
  (209694, 'قابِلِ‌توجُّه (فوق‌العاده)', 'B2', 'C1'), -- remarkable
  (209695, 'بِه‌طورِ چِشمگیر', 'B2', 'C2'), -- remarkably
  (209696, 'گُزارِش‌دِهی', 'B2', 'C1'), -- reporting
  (209697, 'اِستِعفا دادَن', 'B2', 'C1'), -- to resign
  (209699, 'بازگَرداندَن', 'B2', 'C1'), -- to restore
  (209700, 'رِزومه', 'B2', 'C1'), -- résumé
  (209701, 'خُرده‌فُروشی', 'B2', 'C1'), -- retail
  (209702, 'حِفظ کَردَن (نَگَه‌داشتَن)', 'B2', 'C1'), -- to retain
  (209703, 'دَرآمَد', 'B2', 'C1'), -- revenue
  (209704, 'رَها (اَز شَرِّ چیزی)', 'B2', 'C1'), -- rid
  (209705, 'دُزدی کَردَن (سَرِقَت)', 'B2', 'C1'), -- to rob
  (209706, 'عِشق و عاشِقی', 'B2', 'C1'), -- romance
  (209708, 'مالیدَن', 'B2', 'C1'), -- to rub
  (209709, 'لاستیک (مادّه)', 'B2', 'C1'), -- rubber
  (209711, 'دانِشمَند', 'B2', 'C1'), -- scholar
  (209712, 'بَخش (اِقتِصادی)', 'B2', 'C1'), -- sector
  (209714, 'گُزینِش کَردَن', 'B2', 'C1'), -- to select
  (209715, 'مُهاجِرِ ساکِن', 'B2', 'C1'), -- settler
  (209716, 'بِه‌شِدَّت (وَخیم)', 'B2', 'C1'), -- severely
  (209717, 'جَذّاب (جِنسی)', 'B2', 'C1'), -- sexy
  (209719, 'بِه‌شَکلِ', 'B2', 'C1'), -- shaped
  (209720, 'کوتاه‌مُدَّت', 'B2', 'C1'), -- short-term
  (209721, 'بِه‌زودی', 'B2', 'C1'), -- shortly
  (209725, 'جُزئی (کوچَک)', 'B2', 'C1'), -- slight
  (209726, 'اِصطِلاحاً', 'B2', 'C2'), -- so-called
  (209728, 'پیچیده (پیشرَفته)', 'B2', 'C1'), -- sophisticated
  (209729, 'تَخَصُّص داشتَن', 'B2', 'C1'), -- to specialise
  (209731, 'مُشَخَّص کَردَن (دَقیق)', 'B2', 'C1'), -- to specify
  (209732, 'دیدَنی (خیره‌کُننده)', 'B2', 'C1'), -- spectacular
  (209733, 'حَدس و گُمان زَدَن', 'B2', 'C1'), -- to speculate
  (209734, 'گُمانه‌زَنی', 'B2', 'C1'), -- speculation
  (209735, 'ریختَن (سَرریز)', 'B2', 'C1'), -- to spill
  (209736, 'باوُجودِ', 'B2', 'C1'), -- in spite of
  (209737, 'خَراب کَردَن (لَذَّت)', 'B2', 'C1'), -- to spoil
  (209738, 'سُخنگو', 'B2', 'C1'), -- spokesman
  (209739, 'اِسپانسِری', 'B2', 'C2'), -- sponsorship
  (209740, 'خیره شُدَن', 'B2', 'C1'), -- to stare
  (209741, 'گُرسنِگی کِشیدَن', 'B2', 'C1'), -- to starve
  (209742, 'آمار', 'B2', 'C1'), -- statistic
  (209743, 'بِه‌طورِ پیوَسته', 'B2', 'C1'), -- steadily
  (209744, 'پُرشیب', 'B2', 'C2'), -- steep
  (209745, 'سِفت', 'B2', 'C1'), -- stiff
  (209746, 'تَحریک کَردَن', 'B2', 'C1'), -- to stimulate
  (209747, 'مَوجودی (کالا)', 'B2', 'C1'), -- stock
  (209749, 'قابِلِ‌توجُّه (چِشمگیر)', 'B2', 'C1'), -- striking
  (209750, 'خیره‌کُننده (زیبا)', 'B2', 'C1'), -- stunning
  (209751, 'اَرائه دادَن (تَسلیم)', 'B2', 'C1'), -- to submit
  (209753, 'فوق‌العاده', 'B2', 'C1'), -- super
  (209754, 'مُحاصِره کَردَن (اِحاطه)', 'B2', 'C1'), -- to surround
  (209755, 'مُعَلَّق کَردَن', 'B2', 'C1'), -- to suspend
  (209756, 'پایداری', 'B2', 'C1'), -- sustainability
  (209757, 'پایدار', 'B2', 'C1'), -- sustainable
  (209759, 'نَمادِ ... بودَن', 'B2', 'C1'), -- to symbolise
  (209760, 'دِلسوز', 'B2', 'C1'), -- sympathetic
  (209761, 'داستان (اَفسانه)', 'B2', 'C1'), -- tale
  (209762, 'شیرِ آب', 'B2', 'C1'), -- tap
  (209763, 'فَناورانه', 'B2', 'C1'), -- technological
  (209764, 'بِه‌طورِ مُوَقَّت', 'B2', 'C1'), -- temporarily
  (209765, 'شَرایِط (قَرارداد)', 'B2', 'C1'), -- terms
  (209766, 'بِه‌شِدَّت (وَحشَتناک)', 'B2', 'C1'), -- terribly
  (209767, 'بِه‌شِدَّت تَرساندَن', 'B2', 'C2'), -- to terrify
  (209769, 'کِتابِ دَرسی', 'B2', 'C1'), -- textbook
  (209770, 'رَواندَرمانگَر', 'B2', 'C1'), -- therapist
  (209771, 'رَواندَرمانی', 'B2', 'C1'), -- therapy
  (209772, 'کامِل (دَقیق)', 'B2', 'C1'), -- thorough
  (209775, 'شَست', 'B2', 'C1'), -- thumb
  (209777, 'غَم‌اَنگیز (تِراژیک)', 'B2', 'C1'), -- tragic
  (209778, 'گُذار', 'B2', 'C1'), -- transition
  (209779, 'اَرسال کَردَن (اِنتِقال)', 'B2', 'C1'), -- to transmit
  (209780, 'سِپاه (نیرویِ نِظامی)', 'B2', 'C1'), -- troop
  (209781, 'اِستوایی', 'B2', 'C1'), -- tropical
  (209782, 'آهَنگ (مِلودی)', 'B2', 'C1'), -- tune
  (209783, 'در نِهایَت', 'B2', 'C1'), -- ultimately
  (209784, 'غَیرِقابِلِ‌قَبول', 'B2', 'C2'), -- unacceptable
  (209785, 'عَدَمِ‌قَطعیَّت', 'B2', 'C1'), -- uncertainty
  (209786, 'مُتَحَمِّل شُدَن (تَجرُبه کَردَن)', 'B2', 'C1'), -- to undergo
  (209787, 'بَرعُهده گِرِفتَن', 'B2', 'C1'), -- to undertake
  (209788, 'آشکار شُدَن (باز شُدَن)', 'B2', 'C1'), -- to unfold
  (209789, 'مُتَّحِد کَردَن', 'B2', 'C1'), -- to unite
  (209791, 'تَرغیب کَردَن (اِصرار)', 'B2', 'C1'), -- to urge
  (209792, 'مُعتَبَر', 'B2', 'C1'), -- valid
  (209793, 'تَغییرات (تَنَوُّع)', 'B2', 'C1'), -- variation
  (209795, 'مَحَلِّ بَرگُزاری', 'B2', 'C1'), -- venue
  (209796, 'بِه‌طورِ داوَطَلَبانه', 'B2', 'C1'), -- voluntarily
  (209797, 'رَأی‌گیری', 'B2', 'C1'), -- voting
  (209798, 'عَجیب‌وغَریب', 'B2', 'C1'), -- weird
  (209800, 'بِه‌طورِ گُسترده', 'B2', 'C1'), -- widely
  (209803, 'لَغو کَردَن (رَسمی)', 'C1', 'C2'), -- to abolish
  (209804, 'سِقطِ‌جَنین', 'C1', 'C2'), -- abortion
  (209805, 'پوچ (مَسخَره)', 'C1', 'C2'), -- absurd
  (209807, 'قابِلِ‌دَسترَسی', 'C1', 'C2'), -- accessible
  (209808, 'دَستاوَرد', 'C1', 'C2'), -- accomplishment
  (209810, 'پاسُخگویی', 'C1', 'C2'), -- accountability
  (209811, 'اَنباشتَه کَردَن', 'C1', 'C2'), -- to accumulate
  (209812, 'فَعّال‌سازی', 'C1', 'C2'), -- activation
  (209813, 'فَعّالِ (اِجتِماعی)', 'C1', 'C2'), -- activist
  (209814, 'پایبَند بودَن', 'C1', 'C2'), -- to adhere
  (209815, 'اِداره کَردَن (اَجرا)', 'C1', 'C2'), -- to administer
  (209818, 'نامَطلوب', 'C1', 'C2'), -- adverse
  (209819, 'مُدافِع (حامی)', 'C1', 'C2'), -- advocate
  (209820, 'زیبایی‌شِناختی', 'C1', 'C2'), -- aesthetic
  (209821, 'پِیامَد (پَس‌اَز حادِثه)', 'C1', 'C2'), -- aftermath
  (209823, 'هَم‌راستا کَردَن', 'C1', 'C2'), -- to align
  (209824, 'هَم‌راستایی', 'C1', 'C2'), -- alignment
  (209825, 'اِدِّعایِ اِثبات‌نَشُده', 'C1', 'C2'), -- allegation
  (209826, 'اِدِّعا کَردَن (بی‌سَنَد)', 'C1', 'C2'), -- to allege
  (209827, 'اِدِّعایی', 'C1', 'C2'), -- allegedly
  (209829, 'تَخصیص دادَن', 'C1', 'C2'), -- to allocate
  (209830, 'مَبلَغِ تَخصیصی', 'C1', 'C2'), -- allowance
  (209832, 'اِصلاح کَردَن (قانون)', 'C1', 'C2'), -- to amend
  (209834, 'جَذّاب (دِلپَذیر)', 'C1', 'C2'), -- appealing
  (209835, 'تِشویق کَردَن (دِست‌زَدَن)', 'C1', 'C2'), -- to applaud
  (209836, 'قابِلِ‌اِعمال', 'C1', 'C2'), -- applicable
  (209837, 'مَنصوب کَردَن', 'C1', 'C2'), -- to appoint
  (209838, 'خودسَرانه', 'C1', 'C2'), -- arbitrary
  (209839, 'مِعماری (وابَسته)', 'C1', 'C2'), -- architectural
  (209840, 'عَرصه (میدان)', 'C1', 'C2'), -- arena
  (209841, 'مَجموعه (طیف)', 'C1', 'C2'), -- array
  (209842, 'بِه‌روشَنی بَیان کَردَن', 'C1', 'C2'), -- to articulate
  (209843, 'آرزو (بُلَندپَروازی)', 'C1', 'C2'), -- aspiration
  (209844, 'آرزو داشتَن (بُلَند)', 'C1', 'C2'), -- to aspire
  (209845, 'مونتاژ کَردَن (جَمع کَردَن)', 'C1', 'C2'), -- to assemble
  (209846, 'قاطِعانه بَیان کَردَن', 'C1', 'C2'), -- to assert
  (209847, 'اِظهارِ قاطِع', 'C1', 'C2'), -- assertion
  (209848, 'جَنایَتِ فَجیع', 'C1', 'C2'), -- atrocity
  (209849, 'بِه‌دَست آوَردَن (کَسب)', 'C1', 'C2'), -- to attain
  (209850, 'حُضور (میزانِ)', 'C1', 'C2'), -- attendance
  (209851, 'مُمَیِّزی (حِسابرَسی)', 'C1', 'C2'), -- audit
  (209854, 'خودمُختاری', 'C1', 'C2'), -- autonomy
  (209857, 'پیش‌زَمینه', 'C1', 'C2'), -- backdrop
  (209858, 'پُشتیبان (نُسخه)', 'C1', 'C2'), -- backup
  (209861, 'بَنِر (پَرچَم)', 'C1', 'C2'), -- banner
  (209862, 'لُخت (بی‌پوشِش)', 'C1', 'C2'), -- bare
  (209867, 'مِعیارِ سَنجِش', 'C1', 'C2'), -- benchmark
  (209868, 'زیرِ (پایین‌تَر)', 'C1', 'C2'), -- beneath
  (209869, 'ذینَفِع', 'C1', 'C2'), -- beneficiary
  (209872, 'تِحسین کَردَن (اِستِقبال)', 'C1', 'C2'), -- to hail
  (209873, 'جِدّی (وَخیم)', 'C1', 'C2'), -- grave (serious)
  (209874, 'مُلزَم کَردَن', 'C1', 'C2'), -- to bind
  (209876, 'عَجیب‌وغَریب', 'C1', 'C2'), -- bizarre
  (209880, 'لاف زَدَن', 'C1', 'C2'), -- to boast
  (209882, 'بَرگَشتَن (توپ)', 'C1', 'C2'), -- to bounce
  (209883, 'فُروپاشی (خَرابی)', 'C1', 'C2'), -- breakdown
  (209885, 'پَرورِش دادَن (حَیوان)', 'C1', 'C2'), -- to breed
  (209886, 'پَهنایِ باند', 'C1', 'C2'), -- broadband
  (209887, 'مُرورگَر', 'C1', 'C2'), -- browser
  (209889, 'باقِرَ (میانگیر)', 'C1', 'C2'), -- buffer
  (209890, 'حَجمِ زیاد', 'C1', 'C2'), -- bulk
  (209891, 'سَرمایه‌داری', 'C1', 'C2'), -- capitalism
  (209892, 'سَرمایه‌دار', 'C1', 'C2'), -- capitalist
  (209894, 'کاتالوگ', 'C1', 'C2'), -- catalogue
  (209897, 'مُتَوَقِّف شُدَن (رَسمی)', 'C1', 'C2'), -- to cease
  (209899, 'اُتاق (مَجلِس)', 'C1', 'C2'), -- chamber
  (209900, 'مُشَخَّص کَردَن (ویژِگی)', 'C1', 'C2'), -- to characterise
  (209901, 'مَنشور', 'C1', 'C2'), -- charter
  (209903, 'مُزمِن', 'C1', 'C2'), -- chronic
  (209905, 'گَردِش کَردَن (اِنتِشار)', 'C1', 'C2'), -- to circulate
  (209906, 'گَردِش (اِنتِشار)', 'C1', 'C2'), -- circulation
  (209907, 'بَرخورد (دَرگیری)', 'C1', 'C2'), -- clash
  (209908, 'طَبَقه‌بَندی', 'C1', 'C2'), -- classification
  (209911, 'خوشه (دَسته)', 'C1', 'C2'), -- cluster
  (209912, 'ائتِلاف', 'C1', 'C2'), -- coalition
  (209918, 'ستون‌نویس', 'C1', 'C2'), -- columnist
  (209920, 'آغاز کَردَن (رَسمی)', 'C1', 'C2'), -- to commence
  (209921, 'مُفَسِّر (گویَنده)', 'C1', 'C2'), -- commentator
  (209922, 'کمیسیونِر', 'C1', 'C2'), -- commissioner
  (209924, 'قابِلِ‌مُقایِسه', 'C1', 'C2'), -- comparable
  (209925, 'مَجبور کَردَن (اِلزام)', 'C1', 'C2'), -- to compel
  (209926, 'قانِع‌کُننده', 'C1', 'C2'), -- compelling
  (209928, 'گِردآوَری کَردَن', 'C1', 'C2'), -- to compile
  (209930, 'عارِضه (پیچیدگی)', 'C1', 'C2'), -- complication
  (209932, 'تَشکیل دادَن (شامِل)', 'C1', 'C2'), -- to comprise
  (209933, 'مُحاسِبه کَردَن (رایانه‌ای)', 'C1', 'C2'), -- to compute
  (209935, 'اِذعان کَردَن (تَسلیم)', 'C1', 'C2'), -- to concede
  (209937, 'تَصَوُّر (مَفهوم)', 'C1', 'C2'), -- conception
  (209938, 'اِمتیاز (عَقب‌نِشینی)', 'C1', 'C2'), -- concession
  (209941, 'پیکربَندی', 'C1', 'C2'), -- configuration
  (209942, 'مَحدود کَردَن (زِندانی)', 'C1', 'C2'), -- to confine
  (209944, 'کُنگره‌ای', 'C1', 'C2'), -- congressional
  (209947, 'حِفظ کَردَن (مُحیط‌زیست)', 'C1', 'C2'), -- to conserve
  (209948, 'ثَبات (یِکنواختی)', 'C1', 'C2'), -- consistency
  (209949, 'تَحکیم کَردَن', 'C1', 'C2'), -- to consolidate
  (209950, 'تَحکیم (ادِغام)', 'C1', 'C2'), -- consolidation
  (209951, 'تَشکیل دادَن (تَعریف)', 'C1', 'C2'), -- to constitute
  (209953, 'تَعَمُّق کَردَن', 'C1', 'C2'), -- to contemplate
  (209955, 'اِدِّعا کَردَن (مُنازِعه)', 'C1', 'C2'), -- to contend
  (209956, 'رَقیب (نامزَد)', 'C1', 'C2'), -- contender
  (209957, 'اِدِّعا (اِختِلاف)', 'C1', 'C2'), -- contention
  (209960, 'مُخالِف (بَرعَکس)', 'C1', 'C2'), -- contrary
  (209961, 'مُشارِکت‌کُننده', 'C1', 'C2'), -- contributor
  (209962, 'مَحکوم (زِندانی)', 'C1', 'C2'), -- convict
  (209963, 'هَمکاری کَردَن (تَعاوُن)', 'C1', 'C2'), -- to cooperate
  (209964, 'تَعاونی', 'C1', 'C2'), -- cooperative
  (209966, 'هَماهَنگ‌کُننده', 'C1', 'C2'), -- coordinator
  (209967, 'حَقِّ‌تألیف', 'C1', 'C2'), -- copyright
  (209968, 'هَمبَستِگی داشتَن', 'C1', 'C2'), -- to correlate
  (209969, 'هَمبَستِگی', 'C1', 'C2'), -- correlation
  (209970, 'مُطابَقَت داشتَن (مُکاتِبه)', 'C1', 'C2'), -- to correspond
  (209972, 'مُتناظِر', 'C1', 'C2'), -- corresponding
  (209973, 'بِه‌طورِ مُتناظِر', 'C1', 'C2'), -- correspondingly
  (209974, 'پُرهَزینه', 'C1', 'C2'), -- costly
  (209979, 'اَدَب (مُجامَله)', 'C1', 'C2'), -- courtesy
  (209981, 'اِعتِبار (باوَرپَذیری)', 'C1', 'C2'), -- credibility
  (209982, 'قابِلِ‌باوَر', 'C1', 'C2'), -- credible
  (209985, 'کِشت کَردَن (پَرورَش)', 'C1', 'C2'), -- to cultivate
  (209987, 'بُرِش (خَبَری)', 'C1', 'C2'), -- cutting
  (209988, 'بَدبین (طَعنه‌آمیز)', 'C1', 'C2'), -- cynical
  (209989, 'آسیب‌رَسان', 'C1', 'C2'), -- damaging
  (209990, 'اَوَّلین ظُهور', 'C1', 'C2'), -- debut
  (209991, 'تَصمیم‌گیری', 'C1', 'C2'), -- decision-making
  (209992, 'مُتِعَهِّد (اِختِصاصی)', 'C1', 'C2'), -- dedicated
  (209994, 'پیش‌فَرض', 'C1', 'C2'), -- default
  (209995, 'قَطعی (نِهایی)', 'C1', 'C2'), -- definitive
  (209997, 'نُماینده (اَعزامی)', 'C1', 'C2'), -- delegate
  (209998, 'مَحکوم کَردَن (اِعلام)', 'C1', 'C2'), -- to denounce
  (210002, 'پایین آمَدَن (نَسَب)', 'C1', 'C2'), -- to descend
  (210003, 'تَعیین کَردَن (نامگُذاری)', 'C1', 'C2'), -- to designate
  (210004, 'بازداشت کَردَن (نِگَه‌داشتَن)', 'C1', 'C2'), -- to detain
  (210005, 'تِشخیص (کَشف)', 'C1', 'C2'), -- detection
  (210009, 'اِبداع کَردَن (طَراحی)', 'C1', 'C2'), -- to devise
  (210010, 'تَشخیص دادَن (پِزِشکی)', 'C1', 'C2'), -- to diagnose
  (210011, 'اِملا کَردَن (دیکته/دیکتِه کَردَن)', 'C1', 'C2'), -- to dictate
  (210014, 'فِهرِست (پوشه)', 'C1', 'C2'), -- directory
  (210015, 'فاجِعه‌بار', 'C1', 'C2'), -- disastrous
  (210016, 'دور اَنداختَن (رَها کَردَن)', 'C1', 'C2'), -- to discard
  (210018, 'آواره کَردَن (جابه‌جا کَردَن)', 'C1', 'C2'), -- to displace
  (210019, 'دَفعِ زُباله', 'C1', 'C2'), -- disposal
  (210020, 'دور اَنداختَن (دَفع کَردَن)', 'C1', 'C2'), -- to dispose of
  (210021, 'مُختَل کَردَن', 'C1', 'C2'), -- to disrupt
  (210022, 'مُنحَل کَردَن (حَل شُدَن)', 'C1', 'C2'), -- to dissolve
  (210023, 'تَمایُز', 'C1', 'C2'), -- distinction
  (210024, 'مُتِمایِز', 'C1', 'C2'), -- distinctive
  (210025, 'تَحریف کَردَن', 'C1', 'C2'), -- to distort
  (210026, 'پَریشانی', 'C1', 'C2'), -- distress
  (210027, 'آزاردِهَنده (نِگَران‌کُننده)', 'C1', 'C2'), -- disturbing
  (210029, 'اَهداکُننده', 'C1', 'C2'), -- donor
  (210030, 'تَخلیه کَردَن (آب)', 'C1', 'C2'), -- to drain
  (210031, 'رانده شُدَن (بی‌هَدَف حَرَکَت کَردَن)', 'C1', 'C2'), -- to drift
  (210032, 'دوگانه', 'C1', 'C2'), -- dual
  (210033, 'لَقَب دادَن (دوبِله کَردَن)', 'C1', 'C2'), -- to dub
  (210034, 'دونَفَره', 'C1', 'C2'), -- duo
  (210035, 'دَرآمَد (حُقوق)', 'C1', 'C2'), -- earnings
  (210036, 'بوم‌شِناختی', 'C1', 'C2'), -- ecological
  (210037, 'اَثَربَخشی', 'C1', 'C2'), -- effectiveness
  (210038, 'خودخواهی (نَفس)', 'C1', 'C2'), -- ego
  (210039, 'مُفَصَّل (دَقیق)', 'C1', 'C2'), -- elaborate
  (210041, 'بالا بُردَن (اَرتِقا)', 'C1', 'C2'), -- to elevate
  (210042, 'واجِدِ‌شَرایِط', 'C1', 'C2'), -- eligible
  (210043, 'دَست بِه‌کار شُدَن (شُروع سَفَر)', 'C1', 'C2'), -- to embark
  (210045, 'مُجَسَّم کَردَن', 'C1', 'C2'), -- to embody
  (210046, 'تَوانمَند کَردَن', 'C1', 'C2'), -- to empower
  (210047, 'تَصویب کَردَن (قانون)', 'C1', 'C2'), -- to enact
  (210048, 'دَربَرگِرِفتَن', 'C1', 'C2'), -- to encompass
  (210049, 'تَلاش (اِقدام)', 'C1', 'C2'), -- endeavour
  (210050, 'بی‌پایان', 'C1', 'C2'), -- endless
  (210051, 'تأیید کَردَن (حِمایَت)', 'C1', 'C2'), -- to endorse
  (210053, 'تَحَمُّل کَردَن (تاب‌آوَردَن)', 'C1', 'C2'), -- to endure
  (210054, 'اِجرا کَردَن (قانون)', 'C1', 'C2'), -- to enforce
  (210055, 'اِجرا (قانون)', 'C1', 'C2'), -- enforcement
  (210056, 'نامزَدی (تِعامُل)', 'C1', 'C2'), -- engagement
  (210057, 'جَذّاب (سَرگَرم‌کُننده)', 'C1', 'C2'), -- engaging
  (210058, 'غَنی کَردَن', 'C1', 'C2'), -- to enrich
  (210060, 'بَنگاهِ اِقتِصادی', 'C1', 'C2'), -- enterprise
  (210061, 'عَلاقه‌مَندِ پُرشور', 'C1', 'C2'), -- enthusiast
  (210062, 'مُستَحِق کَردَن (عُنوان دادَن)', 'C1', 'C2'), -- to entitle
  (210063, 'هَمه‌گیری', 'C1', 'C2'), -- epidemic
  (210065, 'تَشدید یافتَن', 'C1', 'C2'), -- to escalate
  (210067, 'تَخلیه کَردَن (اَفراد)', 'C1', 'C2'), -- to evacuate
  (210069, 'تَکاملی', 'C1', 'C2'), -- evolutionary
  (210072, 'اِستِثنا (حَذف)', 'C1', 'C2'), -- exclusion
  (210073, 'اِجرا کَردَن (اِعدام)', 'C1', 'C2'), -- to execute
  (210074, 'اِعمال کَردَن (نُفوذ)', 'C1', 'C2'), -- to exert
  (210076, 'مُنقَضی شُدَن', 'C1', 'C2'), -- to expire
  (210078, 'تَسهیل کَردَن', 'C1', 'C2'), -- to facilitate
  (210079, 'مَحو شُدَن (کِم‌رَنگ شُدَن)', 'C1', 'C2'), -- to fade
  (210081, 'دَستاوَردِ چِشمگیر', 'C1', 'C2'), -- feat
  (210083, 'فِمینیست', 'C1', 'C2'), -- feminist
  (210084, 'فیبَر (اَلیاف)', 'C1', 'C2'), -- fibre
  (210085, 'فیلمساز', 'C1', 'C2'), -- filmmaker
  (210088, 'مالی (بودجه‌ای)', 'C1', 'C2'), -- fiscal
  (210090, 'فِرار کَردَن (گُریختَن)', 'C1', 'C2'), -- to flee
  (210092, 'شِکوفا شُدَن', 'C1', 'C2'), -- to flourish
  (210095, 'پیش‌بینی کَردَن (آینده)', 'C1', 'C2'), -- to foresee
  (210097, 'تدوین کَردَن', 'C1', 'C2'), -- to formulate
  (210098, 'بِه‌پیش', 'C1', 'C2'), -- forth
  (210099, 'پیشِ‌رو (آینده)', 'C1', 'C2'), -- forthcoming
  (210100, 'پَرورِش دادَن (تِشویق)', 'C1', 'C2'), -- to foster
  (210101, 'فِرَنچایز (اِمتیاز تِجاری)', 'C1', 'C2'), -- franchise
  (210102, 'ناکام‌کُننده', 'C1', 'C2'), -- frustrating
  (210103, 'ناکامی', 'C1', 'C2'), -- frustration
  (210104, 'عَمَلکَردی (کارآمَد)', 'C1', 'C2'), -- functional
  (210107, 'تَجهیزات (دَنده)', 'C1', 'C2'), -- gear
  (210108, 'عُمومی (غَیرِبَرَندی)', 'C1', 'C2'), -- generic
  (210109, 'نَسل‌کُشی', 'C1', 'C2'), -- genocide
  (210110, 'نِگاهِ اِجمالی', 'C1', 'C2'), -- glimpse
  (210112, 'لُطف (وَقار)', 'C1', 'C2'), -- grace
  (210113, 'دَرک کَردَن (چَنگ زَدَن)', 'C1', 'C2'), -- to grasp
  (210115, 'آسیاب کَردَن (سائیدَن)', 'C1', 'C2'), -- to grind
  (210116, 'ناخالِص (کُلّی)', 'C1', 'C2'), -- gross
  (210117, 'رودِه (شِکَم)', 'C1', 'C2'), -- gut
  (210118, 'نیمه‌راه', 'C1', 'C2'), -- halfway
  (210119, 'مُتَوَقِّف کَردَن (اِیستادَن)', 'C1', 'C2'), -- to halt
  (210120, 'دَستی (کاربَردی)', 'C1', 'C2'), -- handy
  (210121, 'سَخت‌اَفزار', 'C1', 'C2'), -- hardware
  (210122, 'خَشن (سَخت)', 'C1', 'C2'), -- harsh
  (210125, 'تَسخیر کَردَن (ذِهن را رَها نَکَردَن)', 'C1', 'C2'), -- to haunt
  (210126, 'خَطَر (رِیسک)', 'C1', 'C2'), -- hazard
  (210128, 'تِشدید کَردَن (اَفزایِش)', 'C1', 'C2'), -- to heighten
  (210129, 'سِلسِله‌مَراتِب', 'C1', 'C2'), -- hierarchy
  (210130, 'پُرسَروصَدا (سَرشناس)', 'C1', 'C2'), -- high-profile
  (210131, 'ایدئولوژیک', 'C1', 'C2'), -- ideological
  (210132, 'تَصویرسازی (اِستِعاره)', 'C1', 'C2'), -- imagery
  (210133, 'قَریب‌الوُقوع', 'C1', 'C2'), -- imminent
  (210136, 'ناکافی', 'C1', 'C2'), -- inadequate
  (210137, 'زِندانی کَردَن (حَبس)', 'C1', 'C2'), -- to incarcerate
  (210139, 'میزانِ وُقوع', 'C1', 'C2'), -- incidence
  (210140, 'گُنجانِدن (شُمول)', 'C1', 'C2'), -- inclusion
  (210141, 'مُتَحَمِّل شُدَن (هَزینه)', 'C1', 'C2'), -- to incur
  (210142, 'کِیفَرخواست', 'C1', 'C2'), -- indictment
  (210143, 'القا کَردَن (وادار کَردَن)', 'C1', 'C2'), -- to induce
  (210144, 'لَذَّت بُردَن (اِفراط کَردَن)', 'C1', 'C2'), -- to indulge
  (210145, 'آلوده کَردَن (عَفونی)', 'C1', 'C2'), -- to infect
  (210146, 'تَحمیل کَردَن (آسیب)', 'C1', 'C2'), -- to inflict
  (210149, 'آغاز کَردَن (راه‌اَندازی)', 'C1', 'C2'), -- to initiate
  (210152, 'اِستِعلام کَردَن (پُرسیدَن)', 'C1', 'C2'), -- to inquire
  (210153, 'خودی (مُطَّلِع)', 'C1', 'C2'), -- insider
  (210155, 'نِهادی', 'C1', 'C2'), -- institutional
  (210156, 'دَستور دادَن (آموزِش دادَن)', 'C1', 'C2'), -- to instruct
  (210157, 'اَساسی (جُدایی‌ناپَذیر)', 'C1', 'C2'), -- integral
  (210158, 'مُؤَثِّر (اَبزاری)', 'C1', 'C2'), -- instrumental
  (210159, 'دَست‌نَخورده', 'C1', 'C2'), -- intact
  (210161, 'تِشدید کَردَن', 'C1', 'C2'), -- to intensify
  (210162, 'فِشُرده (شَدید)', 'C1', 'C2'), -- intensive
  (210163, 'تِعاملی', 'C1', 'C2'), -- interactive
  (210164, 'رابِط (کاربَری)', 'C1', 'C2'), -- interface
  (210166, 'مُوَقَّت (اِنتِقالی)', 'C1', 'C2'), -- interim
  (210169, 'جالِبِ‌توجُّه', 'C1', 'C2'), -- intriguing
  (210171, 'اِستِناد کَردَن (فَراخوانی)', 'C1', 'C2'), -- to invoke
  (210172, 'دِرگیری (مُشارِکَت)', 'C1', 'C2'), -- involvement
  (210173, 'طَعنه‌آمیز', 'C1', 'C2'), -- ironic
  (210174, 'اَز رویِ طَعنه', 'C1', 'C2'), -- ironically
  (210175, 'صَلاحیَّتِ قانونی', 'C1', 'C2'), -- jurisdiction
  (210176, 'نَقطِه‌یِ‌عَطف (بَنایِ‌تاریخی)', 'C1', 'C2'), -- landmark
  (210177, 'گُسترَده (بُزُرگ‌مِقیاس)', 'C1', 'C2'), -- large-scale
  (210178, 'دُوُمی (اَخیر)', 'C1', 'C2'), -- latter
  (210179, 'قانونگُذار', 'C1', 'C2'), -- lawmaker
  (210181, 'اُفسانه‌ای', 'C1', 'C2'), -- legendary
  (210182, 'قانونگُذاری', 'C1', 'C2'), -- legislation
  (210183, 'قانونگُذاری (وابَسته)', 'C1', 'C2'), -- legislative
  (210184, 'مَجلِسِ قانونگُذاری', 'C1', 'C2'), -- legislature
  (210186, 'هَمجِنسگَرا (زَن)', 'C1', 'C2'), -- lesbian
  (210187, 'کِمتَر (کوچَک‌تَر)', 'C1', 'C2'), -- lesser
  (210188, 'مَسئول (مَسئولیَّت‌پَذیر)', 'C1', 'C2'), -- liable
  (210190, 'آزادی (فَردی)', 'C1', 'C2'), -- liberty
  (210191, 'مادام‌العُمر', 'C1', 'C2'), -- lifelong
  (210192, 'اِحتِمالِ‌وُقوع', 'C1', 'C2'), -- likelihood
  (210193, 'عُضوِ بَدَن (دَست‌وپا)', 'C1', 'C2'), -- limb
  (210196, 'باقی ماندَن (طولانی)', 'C1', 'C2'), -- to linger
  (210197, 'فِهرِست (آگَهی)', 'C1', 'C2'), -- listing
  (210198, 'دیرینه', 'C1', 'C2'), -- long-standing
  (210199, 'دیرینه (طولانی‌مُدَّت)', 'C1', 'C2'), -- long-time
  (210200, 'نَمایان شُدَن (تِهدیدآمیز)', 'C1', 'C2'), -- to loom
  (210201, 'حَلقه (چَرخه)', 'C1', 'C2'), -- loop
  (210202, 'ماشین‌آلات', 'C1', 'C2'), -- machinery
  (210203, 'بُزُرگی (اَندازه)', 'C1', 'C2'), -- magnitude
  (210208, 'دَست‌نِویس', 'C1', 'C2'), -- manuscript
  (210209, 'حاشیه‌ای (جُزئی)', 'C1', 'C2'), -- marginal
  (210210, 'بازار (تِجاری)', 'C1', 'C2'), -- marketplace
  (210211, 'ریاضی (وابَسته)', 'C1', 'C2'), -- mathematical
  (210212, 'بالِغ (پُخته)', 'C1', 'C2'), -- mature
  (210213, 'بیشینه کَردَن', 'C1', 'C2'), -- to maximise
  (210214, 'مَعنادار', 'C1', 'C2'), -- meaningful
  (210215, 'هَمین اَثنا', 'C1', 'C2'), -- meantime
  (210216, 'قُرونِ‌وُسطایی', 'C1', 'C2'), -- medieval
  (210217, 'یادداشتِ اِداری', 'C1', 'C2'), -- memo
  (210218, 'خاطِرات (کِتاب)', 'C1', 'C2'), -- memoir
  (210219, 'صِرفاً (تَنها)', 'C1', 'C2'), -- merely
  (210221, 'در بَحبوحه‌یِ', 'C1', 'C2'), -- in the midst of
  (210222, 'مُبارِزِ تُندرَو', 'C1', 'C2'), -- militant
  (210224, 'حَداقَلی', 'C1', 'C2'), -- minimal
  (210226, 'مَعدَنکاری', 'C1', 'C2'), -- mining
  (210227, 'گُمراه‌کُننده', 'C1', 'C2'), -- misleading
  (210228, 'سوءِمَدیریَّت', 'C1', 'C2'), -- mismanagement
  (210229, 'اَنبوهِ خَشمگین (اوباش)', 'C1', 'C2'), -- mob
  (210230, 'بَسیج کَردَن', 'C1', 'C2'), -- to mobilise
  (210231, 'مُعتَدِل', 'C1', 'C2'), -- moderate
  (210232, 'اِصلاح (تَغییرِ جُزئی)', 'C1', 'C2'), -- modification
  (210233, 'مازول (واحِدِ آموزِشی)', 'C1', 'C2'), -- module
  (210234, 'شِتاب (اِندازه‌حَرَکَت)', 'C1', 'C2'), -- momentum
  (210235, 'اِنحِصار', 'C1', 'C2'), -- monopoly
  (210237, 'شَهرداری (وابَسته)', 'C1', 'C2'), -- municipal
  (210238, 'ساده‌لَوح', 'C1', 'C2'), -- naive
  (210239, 'بِه‌عِبارَتِ‌دیگَر', 'C1', 'C2'), -- namely
  (210240, 'سَراسَری', 'C1', 'C2'), -- nationwide
  (210241, 'دَریایی (نِظامی)', 'C1', 'C2'), -- naval
  (210242, 'غَفلَت کَردَن', 'C1', 'C2'), -- to neglect
  (210243, 'هَمسایه (مُجاوِر)', 'C1', 'C2'), -- neighbouring
  (210244, 'سَر تَکان دادَن', 'C1', 'C2'), -- to nod
  (210246, 'نامزَدی (اِنتِخاب)', 'C1', 'C2'), -- nomination
  (210248, 'بااین‌حال', 'C1', 'C2'), -- nonetheless
  (210249, 'هَنجار (اِستاندارد)', 'C1', 'C2'), -- norm
  (210251, 'مُلزَم کَردَن (اِجبار)', 'C1', 'C2'), -- to oblige
  (210253, 'گاه‌به‌گاه', 'C1', 'C2'), -- occasional
  (210254, 'اِحتِمالات (شانس)', 'C1', 'C2'), -- odds
  (210256, 'اِنتِخاب کَردَن (تَرجیح)', 'C1', 'C2'), -- to opt
  (210257, 'خوش‌بینی', 'C1', 'C2'), -- optimism
  (210259, 'جِهت‌گیری (آشنایی)', 'C1', 'C2'), -- orientation
  (210260, 'سَرچَشمه گِرِفتَن', 'C1', 'C2'), -- to originate
  (210261, 'فُروشگاهِ زَنجیره‌ای (مَنفَذ)', 'C1', 'C2'), -- outlet
  (210264, 'بیش‌اَزحَد', 'C1', 'C2'), -- overly
  (210266, 'غالِب شُدَن بَر (تَحتِ‌فِشار قِراردادَن)', 'C1', 'C2'), -- to overwhelm
  (210267, 'بِسیار زیاد (طاقَت‌فَرسا)', 'C1', 'C2'), -- overwhelming
  (210268, 'پارامِتِر (مِعیار)', 'C1', 'C2'), -- parameter
  (210269, 'والِدَینی (پِدَرومادَری)', 'C1', 'C2'), -- parental
  (210272, 'اِختِراع (حَقِّ‌اِمتیاز)', 'C1', 'C2'), -- patent
  (210273, 'مَسیر (راه)', 'C1', 'C2'), -- pathway
  (210274, 'عَجیب (خاص)', 'C1', 'C2'), -- peculiar
  (210275, 'پافِشاری کَردَن', 'C1', 'C2'), -- to persist
  (210277, 'قابِلِ‌قَبول (بِاوَرکَردَنی)', 'C1', 'C2'), -- plausible
  (210278, 'التِماس کَردَن (اِقرار)', 'C1', 'C2'), -- to plead
  (210279, 'تِعَهُّد (قَول)', 'C1', 'C2'), -- pledge
  (210280, 'سُقوطِ‌شَدید', 'C1', 'C2'), -- plunge
  (210281, 'سَبَدِ سَرمایه (پورتفولیو)', 'C1', 'C2'), -- portfolio
  (210282, 'بِه‌تَصویر کِشیدَن (تِرسیم)', 'C1', 'C2'), -- to portray
  (210283, 'بِه‌تَعویق اَنداختَن', 'C1', 'C2'), -- to postpone
  (210284, 'پَس‌اَز‌جَنگ', 'C1', 'C2'), -- post-war
  (210285, 'مُتَخَصِّص (شاغِل)', 'C1', 'C2'), -- practitioner
  (210287, 'مُقَدَّم بودَن بَر', 'C1', 'C2'), -- to precede
  (210288, 'سابِقه (پیشینه)', 'C1', 'C2'), -- precedent
  (210289, 'دِقَّت (تَکنیکی)', 'C1', 'C2'), -- precision
  (210290, 'سَلَف (پیشین)', 'C1', 'C2'), -- predecessor
  (210291, 'عَمدَتاً', 'C1', 'C2'), -- predominantly
  (210294, 'نُخُست‌وَزیر', 'C1', 'C2'), -- premier
  (210295, 'مُقَدِّمه (پیش‌فَرض)', 'C1', 'C2'), -- premise
  (210296, 'حَقِّ‌بیمه (اَضافه‌بَها)', 'C1', 'C2'), -- premium
  (210298, 'دَراین‌لَحظه (اَکنون)', 'C1', 'C2'), -- presently
  (210301, 'فَرض کَردَن (گُمان)', 'C1', 'C2'), -- to presume
  (210302, 'غالِب شُدَن (رایج بودَن)', 'C1', 'C2'), -- to prevail
  (210304, 'خصوصی‌سازی', 'C1', 'C2'), -- privatization
  (210305, 'اِمتیاز (وِیژه)', 'C1', 'C2'), -- privilege
  (210306, 'تَحقیقات (کاوِش)', 'C1', 'C2'), -- probe
  (210307, 'مَسئله‌ساز', 'C1', 'C2'), -- problematic
  (210308, 'رَوَند (اِقدامات قانونی)', 'C1', 'C2'), -- proceeding
  (210309, 'عایدات (دَرآمَدِ حاصِل)', 'C1', 'C2'), -- proceeds
  (210312, 'بَهرَه‌وَری', 'C1', 'C2'), -- productivity
  (210313, 'عَمیق (بُنیادی)', 'C1', 'C2'), -- profound
  (210314, 'پیش‌بینی (تَخمین)', 'C1', 'C2'), -- projection
  (210315, 'مُشَخَّص (بارِز)', 'C1', 'C2'), -- pronounced
  (210316, 'تَحتِ‌تَعقیب قِراردادَن', 'C1', 'C2'), -- to prosecute
  (210317, 'تَعقیبِ‌قَضایی', 'C1', 'C2'), -- prosecution
  (210318, 'بالقُوّه (آینده)', 'C1', 'C2'), -- prospective
  (210320, 'اِستانی (وِلایَتی)', 'C1', 'C2'), -- provincial
  (210321, 'تَحریک کَردَن (بَرانگیختَن)', 'C1', 'C2'), -- to provoke
  (210323, 'پُرسِش (اِستِعلام)', 'C1', 'C2'), -- query
  (210324, 'جُستُجو (تِلاش)', 'C1', 'C2'), -- quest
  (210325, 'خَشمِ‌شَدید (غَضَب)', 'C1', 'C2'), -- rage
  (210326, 'رُتبه‌بَندی', 'C1', 'C2'), -- ranking
  (210328, 'نِسبَت (تَناسُب)', 'C1', 'C2'), -- ratio
  (210329, 'پَرتو (اَشِعِّه)', 'C1', 'C2'), -- ray
  (210330, 'بِه‌راحَتی (فوراً)', 'C1', 'C2'), -- readily
  (210331, 'عَقَب (پُشت)', 'C1', 'C2'), -- rear
  (210333, 'دَریافت‌کُننده', 'C1', 'C2'), -- recipient
  (210334, 'بازگو کَردَن', 'C1', 'C2'), -- to recount
  (210335, 'اِستِخدام (جَذبِ‌نیرو)', 'C1', 'C2'), -- recruitment
  (210336, 'هَمه‌پُرسی', 'C1', 'C2'), -- referendum
  (210337, 'بازپَس‌گِرِفتَن', 'C1', 'C2'), -- to regain
  (210338, 'صَرف‌نَظَر (بی‌توجُّه بِه)', 'C1', 'C2'), -- regardless
  (210339, 'رِژیم (حُکومَت)', 'C1', 'C2'), -- regime
  (210340, 'نِهادِ‌ناظِر', 'C1', 'C2'), -- regulator
  (210342, 'قابِلیَّتِ‌اِطمینان', 'C1', 'C2'), -- reliability
  (210343, 'بی‌میل (اِکراه)', 'C1', 'C2'), -- reluctant
  (210345, 'تَبدیل کَردَن (اَرائه دادَن)', 'C1', 'C2'), -- to render
  (210346, 'تَمدید کَردَن (نو کَردَن)', 'C1', 'C2'), -- to renew
  (210347, 'اِجاره‌ای', 'C1', 'C2'), -- rental
  (210348, 'بِنابِرِگُزارِش‌ها', 'C1', 'C2'), -- reportedly
  (210349, 'نُمایِندگی (بازنُمایی)', 'C1', 'C2'), -- representation
  (210350, 'بازتولید کَردَن (تَکثیر)', 'C1', 'C2'), -- to reproduce
  (210351, 'شَباهَت داشتَن بِه', 'C1', 'C2'), -- to resemble
  (210352, 'باقی‌مانده (رُسوب)', 'C1', 'C2'), -- residue
  (210353, 'مَربوطه (هَرکُدام)', 'C1', 'C2'), -- respective
  (210354, 'بِه‌تَرتیب', 'C1', 'C2'), -- respectively
  (210360, 'فَنِّ‌بَیان (سُخَنوَری)', 'C1', 'C2'), -- rhetoric
  (210362, 'آیین (مَراسِم)', 'C1', 'C2'), -- ritual
  (210363, 'تازِه‌کار', 'C1', 'C2'), -- rookie
  (210364, 'فِهرِستِ‌اَعضا', 'C1', 'C2'), -- roster
  (210365, 'چَرخیدَن (دَورانی)', 'C1', 'C2'), -- to rotate
  (210366, 'چَرخِش (دَوران)', 'C1', 'C2'), -- rotation
  (210369, 'مُنجی (نَجات‌دِهَنده)', 'C1', 'C2'), -- saviour
  (210370, 'بَخش (قِسمَت)', 'C1', 'C2'), -- segment
  (210371, 'تَصَرُّف کَردَن (توقیف)', 'C1', 'C2'), -- to seize
  (210372, 'بِه‌ندرَت', 'C1', 'C2'), -- seldom
  (210373, 'گُزینِشی', 'C1', 'C2'), -- selective
  (210374, 'هیجانِ‌عُمومی (اِحساس)', 'C1', 'C2'), -- sensation
  (210375, 'اِحساسات (نَظَر)', 'C1', 'C2'), -- sentiment
  (210376, 'سِریالی (پِیاپِی)', 'C1', 'C2'), -- serial
  (210377, 'راه‌اَندازی (تِرکیب)', 'C1', 'C2'), -- setup
  (210378, 'گَرایِشِ‌جِنسی', 'C1', 'C2'), -- sexuality
  (210379, 'خُرد کَردَن (شِکَستَن)', 'C1', 'C2'), -- to shatter
  (210380, 'ریختَن (اَشک/مو) (دور اَنداختَن)', 'C1', 'C2'), -- to shed
  (210381, 'مَحض (صِرف)', 'C1', 'C2'), -- sheer
  (210382, 'کوچَک شُدَن (جَمع‌شُدَن)', 'C1', 'C2'), -- to shrink
  (210383, 'شانه بالا اَنداختَن', 'C1', 'C2'), -- to shrug
  (210386, 'شِبیه‌سازی', 'C1', 'C2'), -- simulation
  (210387, 'واقِع‌شُده', 'C1', 'C2'), -- situated
  (210388, 'شَکّاک (بَدبین)', 'C1', 'C2'), -- sceptical
  (210389, 'طَرحِ اَوَّلیه (اِسکیس)', 'C1', 'C2'), -- sketch
  (210390, 'بُریدَگی (کاهِشِ‌شَدید)', 'C1', 'C2'), -- slash
  (210392, 'شِکاف (زَمانِ‌اَختِصاصی)', 'C1', 'C2'), -- slot
  (210393, 'خُرد کَردَن (شِکَستَن‌شَدید)', 'C1', 'C2'), -- to smash
  (210395, 'خیس کَردَن (خیساندَن)', 'C1', 'C2'), -- to soak
  (210397, 'تَنها (اِنحِصاری)', 'C1', 'C2'), -- sole
  (210398, 'فَقَط (اِنحِصاراً)', 'C1', 'C2'), -- solely
  (210399, 'دامَنه (بازِه)', 'C1', 'C2'), -- span
  (210401, 'مُشَخَّصات (فَنّی)', 'C1', 'C2'), -- specification
  (210402, 'نُمونه (سَمپِل)', 'C1', 'C2'), -- specimen
  (210403, 'مَنظَره‌یِ‌دیدَنی (نُمایِش)', 'C1', 'C2'), -- spectacle
  (210404, 'کُره (حیطه)', 'C1', 'C2'), -- sphere
  (210405, 'سُتونِ‌فَقَرات', 'C1', 'C2'), -- spine
  (210408, 'با‌ثبات کَردَن', 'C1', 'C2'), -- to stabilise
  (210409, 'سَهم (رِیسک)', 'C1', 'C2'), -- stake
  (210410, 'آشکار (خَشک و رُک)', 'C1', 'C2'), -- stark
  (210412, 'هِدایَت کَردَن (فَرمان)', 'C1', 'C2'), -- to steer
  (210414, 'رِشته (تار)', 'C1', 'C2'), -- strand
  (210415, 'نَوار (باریکه)', 'C1', 'C2'), -- strip
  (210416, 'تِلاشِ‌پیگیر کَردَن', 'C1', 'C2'), -- to strive
  (210417, 'ساختاری', 'C1', 'C2'), -- structural
  (210418, 'سِکَندَری خوردَن', 'C1', 'C2'), -- to stumble
  (210419, 'مَبهوت کَردَن (شوکه کَردَن)', 'C1', 'C2'), -- to stun
  (210420, 'اَرائه (تَسلیم)', 'C1', 'C2'), -- submission
  (210422, 'بَعدی (پَسین)', 'C1', 'C2'), -- subsequent
  (210423, 'سِپَس (بَعدها)', 'C1', 'C2'), -- subsequently
  (210424, 'یارانه', 'C1', 'C2'), -- subsidy
  (210425, 'قابِلِ‌توجُّه (عُمده)', 'C1', 'C2'), -- substantial
  (210428, 'حومه‌ای', 'C1', 'C2'), -- suburban
  (210429, 'مُتِوالی (پِیاپِی)', 'C1', 'C2'), -- successive
  (210430, 'شِکایَتِ‌قَضایی کَردَن', 'C1', 'C2'), -- to sue
  (210431, 'عالی (فوق‌العاده)', 'C1', 'C2'), -- superb
  (210432, 'بازرَس (سَرپَرَست)', 'C1', 'C2'), -- superintendent
  (210433, 'نَظارَت کَردَن (سَرپَرَستی)', 'C1', 'C2'), -- to supervise
  (210434, 'حِمایَتگَر', 'C1', 'C2'), -- supportive
  (210437, 'عالی (اَعلا)', 'C1', 'C2'), -- supreme
  (210438, 'اَفزایِشِ‌ناگَهانی', 'C1', 'C2'), -- surge
  (210439, 'جِراحی (وابَسته)', 'C1', 'C2'), -- surgical
  (210440, 'مُراقِبَت (نَظارَتِ‌اَمنیَّتی)', 'C1', 'C2'), -- surveillance
  (210441, 'مُلایِم (لَطیف)', 'C1', 'C2'), -- tender (gentle)
  (210442, 'ادامه دادَن (تَحَمُّل کَردَن)', 'C1', 'C2'), -- to sustain
  (210443, 'نِظام‌مَند', 'C1', 'C2'), -- systematic
  (210446, 'مالیات‌دِهَنده', 'C1', 'C2'), -- taxpayer
  (210448, 'دَورِه‌یِ‌تَصَدّی', 'C1', 'C2'), -- tenure
  (210450, 'زَمین (توپوگرافی)', 'C1', 'C2'), -- terrain
  (210451, 'فوق‌العاده (عالی)', 'C1', 'C2'), -- terrific
  (210455, 'نِمایِشی (تِئاتری)', 'C1', 'C2'), -- theatrical
  (210457, 'پَس‌اَز‌آن', 'C1', 'C2'), -- thereafter
  (210458, 'بِدین‌تَرتیب', 'C1', 'C2'), -- thereby
  (210460, 'شِکوفا شُدَن (رونَق گِرِفتَن)', 'C1', 'C2'), -- to thrive
  (210461, 'جَزر و مَد', 'C1', 'C2'), -- tide
  (210463, 'چوبِ‌ساختِمانی', 'C1', 'C2'), -- timber
  (210464, 'بِه‌موقِع', 'C1', 'C2'), -- timely
  (210465, 'عَوارِض (تَلَفات)', 'C1', 'C2'), -- toll
  (210467, 'عَلامَتِ‌تِجاری', 'C1', 'C2'), -- trademark
  (210469, 'مَتنِ‌پیاده‌شُده', 'C1', 'C2'), -- transcript
  (210470, 'ضَربه‌یِ‌رَوانی', 'C1', 'C2'), -- trauma
  (210471, 'بِسیار زیاد (شِگِرف)', 'C1', 'C2'), -- tremendous
  (210472, 'قَبیله‌ای', 'C1', 'C2'), -- tribal
  (210473, 'عامِلِ‌مُحَرِّک (ماشه)', 'C1', 'C2'), -- trigger
  (210474, 'سِه‌نَفَره', 'C1', 'C2'), -- trio
  (210475, 'پیروزیِ‌بُزُرگ', 'C1', 'C2'), -- triumph
  (210476, 'پُرمَسئَله (نِگَران)', 'C1', 'C2'), -- troubled
  (210479, 'میزانِ‌مُشارِکَت', 'C1', 'C2'), -- turnout
  (210480, 'گَردِشِ‌مالی', 'C1', 'C2'), -- turnover
  (210481, 'غَیرِقانونِ‌اَساسی', 'C1', 'C2'), -- unconstitutional
  (210482, 'دانِشجویِ‌کارشِناسی', 'C1', 'C2'), -- undergraduate
  (210483, 'زیرِبَنایی (اَصلی)', 'C1', 'C2'), -- underlying
  (210484, 'تِضعیف کَردَن', 'C1', 'C2'), -- to undermine
  (210485, 'بی‌شَک', 'C1', 'C2'), -- undoubtedly
  (210486, 'مُتَّحِد کَردَن (یِکپارچه)', 'C1', 'C2'), -- to unify
  (210487, 'بی‌سابِقه', 'C1', 'C2'), -- unprecedented
  (210488, 'رونَمایی کَردَن', 'C1', 'C2'), -- to unveil
  (210489, 'پیشِ‌رو (آینده)', 'C1', 'C2'), -- upcoming
  (210490, 'حِفظ کَردَن (پایبَند مانَدَن)', 'C1', 'C2'), -- to uphold
  (210491, 'بَرق‌وآب (خَدَماتِ‌عُمومی)', 'C1', 'C2'), -- utility
  (210493, 'کاملاً (بِه‌طورِ‌مُطلَق)', 'C1', 'C2'), -- utterly
  (210494, 'ناپَدید شُدَن (کامِل)', 'C1', 'C2'), -- to vanish
  (210495, 'مُتَغَیِّر', 'C1', 'C2'), -- variable
  (210496, 'فَعّالیَّتِ‌پُرریسک (سَرمایه‌گُذاری)', 'C1', 'C2'), -- venture
  (210497, 'تأیید کَردَن (راستی‌آزمایی)', 'C1', 'C2'), -- to verify
  (210498, 'بَند (شِعر)', 'C1', 'C2'), -- verse
  (210500, 'کِشتی (ظَرف)', 'C1', 'C2'), -- vessel
  (210501, 'کُهنه‌کار (کُهنه‌سَرباز)', 'C1', 'C2'), -- veteran
  (210502, 'عَمَلی (قابِلِ‌اَجرا)', 'C1', 'C2'), -- viable
  (210503, 'رَذیله (مُعاوِن)', 'C1', 'C2'), -- vice
  (210504, 'بی‌رَحمانه (خَشِن)', 'C1', 'C2'), -- vicious
  (210506, 'صَریح (صَوتی)', 'C1', 'C2'), -- vocal
  (210507, 'آسیب‌پَذیری', 'C1', 'C2'), -- vulnerability
  (210508, 'بَخشِ‌بیمارِستان (مَنطَقه)', 'C1', 'C2'), -- ward
  (210509, 'جَنگ (نِبَرد)', 'C1', 'C2'), -- warfare
  (210510, 'حُکم (مَجوز)', 'C1', 'C2'), -- warrant
  (210514, 'کاملاً (تَماماً)', 'C1', 'C2'), -- wholly
  (210515, 'گُسترِش دادَن (پَهن‌تَر کَردَن)', 'C1', 'C2'), -- to widen
  (210516, 'تَمایُل (اِشتیاق)', 'C1', 'C2'), -- willingness
  (210517, 'پاک کَردَن (تَمیز کَردَن)', 'C1', 'C2'), -- to wipe
  (210518, 'ذَکاوَت (شوخ‌طَبعی)', 'C1', 'C2'), -- wit
  (210519, 'تَمرینِ‌بَدَنسازی', 'C1', 'C2'), -- workout
  (210569, 'هَرچَند', 'C2', 'C1'), -- albeit
  (210660, 'دِلِ‌خود را بِه دَریا زَدَن', 'C2', 'C1'), -- to bite the bullet
  (210687, 'تَسلیم شُدَن', 'C2', 'C1'), -- to capitulate
  (210710, 'مَخفیانه', 'C2', 'C1'), -- clandestine
  (210774, 'مُقَصِّر', 'C2', 'C1'), -- culpable
  (210817, 'مَسخَره کَردَن', 'C2', 'C1'), -- to deride
  (210913, 'دِرگیر کَردَن', 'C2', 'C1'), -- to embroil
  (211148, 'مانِع', 'C2', 'C1'), -- impediment
  (211152, 'بِه‌خَطَر اَنداختَن', 'C2', 'C1'), -- to imperil
  (211262, 'خَسته و بی‌اِنگیزه', 'C2', 'C1'), -- jaded
  (211267, 'بِه‌خَطَر اَنداختَن', 'C2', 'C1'), -- to jeopardise
  (211299, 'سَرقَت', 'C2', 'C1'), -- larceny
  (211309, 'بی‌حال و کُند', 'C2', 'C1'), -- lethargic
  (211371, 'دُروغگو', 'C2', 'C1'), -- mendacious
  (211400, 'خَفه کَردَنِ‌صِدا', 'C2', 'C1'), -- muffle
  (211648, 'مالِک', 'C2', 'C1'), -- proprietor
  (211660, 'نَزدیکی', 'C2', 'C1'), -- proximity
  (211728, 'اِصلاح', 'C2', 'C1'), -- rectification
  (211790, 'اِنتِقام گِرِفتَن', 'C2', 'C1'), -- retaliate
  (211823, 'مُحافِظَت کَردَن', 'C2', 'C1'), -- safeguard
  (211960, 'تَسلیم شُدَن', 'C2', 'C1'), -- succumb
  (211973, 'حَدس زَدَن', 'C2', 'C1'), -- surmise
  (212068, 'خیانَت', 'C2', 'C1'), -- treachery
  (212134, 'سَرزَنِش کَردَن', 'C2', 'C1'), -- upbraid
  (212437, 'دَربَرگِرِفتَن', 'B1', 'C1'), -- involve
  (212438, 'تَوافُق (هَمخوانی)', 'B2', 'C1'), -- accord
  (212443, 'نامَشخَّص', 'B1', 'B2'), -- unclear
  (212454, 'مَبهوت کَردَن', 'A2', 'B1'), -- amaze
  (212456, 'اِزدِواج کَردَن', 'B1', 'A2'), -- wed
  (212457, 'تِکیه کَردَن', 'B1', 'B2'), -- rely
  (212458, 'دوست‌داشتَنی', 'A1', 'A2'), -- lovely
  (212459, 'تَحلیل کَردَن', 'B1', 'B2'), -- analyze
  (212462, 'تأکید کَردَن', 'B1', 'B2'), -- emphasize
  (212464, 'خوش‌شانس', 'A1', 'A2'), -- lucky
  (212469, 'مَجذوب کَردَن', 'B1', 'B2'), -- fascinate
  (212470, 'زیربَنایِ‌چیزی‌بودَن', 'C1', 'C2'), -- underlie
  (212473, 'اِنتِقاد کَردَن', 'B1', 'B2'), -- criticize
  (212474, 'مُشَخَّص کَردَن (تَوصیف‌کَردَن)', 'C1', 'C2'), -- characterize
  (212475, 'تَخَصُّص داشتَن', 'B1', 'B2'), -- specialize
  (212476, 'مُشاوِره دادَن', 'B1', 'B2'), -- counsel
  (212481, 'لَعنَتی', 'B1', 'A2'), -- damn
  (212486, 'فِعل', 'A1', 'A2'), -- verb
  (212491, 'با‌وَفاداری', 'C1', 'C2'), -- faithfully
  (212584, 'پزو', 'B1', 'B2'), -- peso
  (212586, 'دِرهَم', 'B1', 'B2'), -- dirham
  (212587, 'کرون', 'B1', 'B2'), -- krona
  (212602, 'پوست کَندَن', 'A2', 'B1'), -- peel
  (212603, 'مَرینِیت کَردَن (خوابانَدَنِ‌گوشت)', 'B2', 'C1'), -- marinate
  (212605, 'بَرقکار', 'A2', 'B1'), -- electrician
  (212607, 'روتِر', 'B1', 'C1'), -- router
  (212730, 'دَویدَن', 'A1', 'A2'), -- running
  (212733, 'بَدمینتون', 'A2', 'B1'), -- badminton
  (212736, 'دو‌ومَیدانی', 'B1', 'C1'), -- athletics
  (212737, 'تیرانداژی‌باکَمان', 'B2', 'C1'), -- archery
  (212738, 'جودو', 'B1', 'B2'), -- judo
  (212739, 'تِکواندو', 'B1', 'B2'), -- taekwondo
  (212741, 'سه‌گانه (تِریاتلون)', 'B2', 'C1'), -- triathlon
  (212748, 'وَرزِشکاری (اَخلاقِ‌وَرزِشی)', 'B2', 'C1'), -- sportsmanship
  (212749, 'اِسنوبورد', 'B1', 'C1'), -- snowboarding
  (212750, 'واتِرپولو', 'B2', 'C2'), -- water polo
  (212751, 'بارانی', 'A1', 'A2'), -- rainy
  (212756, 'رَعدوبَرق', 'A2', 'B1'), -- thunderstorm
  (212761, 'بارانِ‌یَخ‌زَده', 'B2', 'C1'), -- sleet
  (212762, 'موسِمی (بادِموسِمی)', 'B2', 'C1'), -- monsoon
  (212764, 'فِشارسَنج (باروَمِتر)', 'B2', 'C1'), -- barometer
  (212767, 'شادمان', 'B1', 'B2'), -- joyful
  (212770, 'غَرقِ‌فِشار (مَغلوبِ‌اِحساسات)', 'B2', 'C1'), -- overwhelmed
  (212780, 'چانه', 'A2', 'B1'), -- chin
  (212788, 'کیوی', 'A2', 'B1'), -- kiwi
  (212789, 'گُل‌فُروش', 'B1', 'C1'), -- florist
  (212790, 'ترشی', 'B1', 'B2'), -- pickle
  (212792, 'قُوّه‌یِ‌حُکومَتی', 'B2', 'C1'), -- branch of government
  (212795, 'گُلبولِ‌خونی', 'B2', 'C1'), -- blood cell
  (212799, 'آفَتِ‌گیاهی', 'B2', 'C1'), -- blight
  (212800, 'قافیه', 'B1', 'B2'), -- rhyme
  (212801, 'اَختِلاس', 'B2', 'C1'), -- embezzlement
  (212802, 'کتیبه', 'B2', 'C1'), -- inscription
  (212803, 'حَماسه', 'B1', 'B2'), -- epic
  (212804, 'بازپَرداخت', 'B1', 'B2'), -- repayment
  (212812, 'ناتَنی (خواهَر/بَرادَرِ‌ناتَنی)', 'B2', 'C1'), -- step-sibling
  (212813, 'عایِق‌کاری', 'B2', 'C1'), -- insulation
  (212816, 'غارنِشین', 'B1', 'B2'), -- cave dweller
  (212823, 'رَمزگُذاری', 'B1', 'B2'), -- encoding
  (212824, 'بَدافزار', 'B1', 'B2'), -- malware
  (212825, 'بازدَم', 'B1', 'B2'), -- exhalation
  (212826, 'تَبخیر', 'B1', 'B2'), -- evaporation
  (212828, 'مَدارِکِ‌صَلاحیَّت', 'B2', 'C1'), -- credentials
  (212838, 'پیشاهَنگی', 'B1', 'B2'), -- scouting
  (212839, 'رُوحانیّون', 'B1', 'B2'), -- clergy
  (212847, 'قابلمِه', 'B1', 'B2'), -- cooking pot
  (212848, 'تِصویربَرداری', 'B2', 'C1'), -- imaging
  (212851, 'نیلی', 'B1', 'C1'), -- indigo
  (212852, 'مَفاهیم', 'B1', 'B2'), -- concepts
  (212854, 'غَیب', 'B2', 'C1'), -- the unseen
  (212855, 'بَرکَنارشُده‌اَزسِمَت', 'B2', 'C1'), -- dismissed from office
  (212856, 'طومار', 'B1', 'B2'), -- scroll
  (212857, 'مُصونیَّت', 'B1', 'B2'), -- immunity
  (212861, 'فَرابَنَفش', 'B1', 'B2'), -- ultraviolet
  (212862, 'اِلِکترومَغناطیسی', 'B1', 'B2'), -- electromagnetic
  (212863, 'تاجگُذاری', 'B1', 'B2'), -- coronation
  (212864, 'بَرگُزاری (تَشکیلِ‌جَلسه)', 'B2', 'C1'), -- convening
  (212865, 'مُهاجِم (حَمله‌کُننده)', 'B2', 'C1'), -- assailant
  (212866, 'کَفّاره', 'C1', 'C2'), -- atonement
  (212868, 'فُرمِ‌اِظهارنامه', 'B2', 'C1'), -- declaration form
  (212869, 'اِشباع', 'B1', 'B2'), -- saturation
  (212888, 'مُشتَق (رِیاضی)', 'B2', 'C1'), -- derivative
  (212892, 'بِدان‌گونه', 'C1', 'C2'), -- in that manner
  (212896, 'تِشکیل‌شُده (بَرگُزارشُده)', 'B2', 'C1'), -- convened
  (212899, 'چَپ‌گَرا', 'B1', 'C1'), -- leftist
  (212905, 'دادخواهی', 'B2', 'C1'), -- seeking justice
  (212917, 'طَبَقاتی', 'B1', 'C1'), -- class-related
  (212920, 'شَدیدتَرین', 'B1', 'B2'), -- most severe
  (212924, 'کارکَردها', 'B1', 'C1'), -- functions
  (212928, 'کَمَند', 'B1', 'C1'), -- lasso
  (212930, 'لاعِلاج', 'B1', 'C1'), -- incurable
  (212938, 'دیوانگان', 'B1', 'C1'), -- madmen
  (212940, 'اِرتِجاعی', 'B1', 'C1'), -- reactionary
  (212943, 'عارِف', 'B1', 'C1'), -- mystic
  (212948, 'فُتوحات', 'C1', 'C2'), -- conquests
  (212957, 'کارکَرد', 'B1', 'B2'), -- function
  (212982, 'عَلاقه‌مَند کَردَن', 'A1', 'A2'), -- to interest
  (212985, 'اُروپایی', 'A1', 'A2'), -- European
  (212987, 'مُعتَبَر بودَن', 'A1', 'A2'), -- to be valid / in effect
  (212989, 'مَبادا', 'A1', 'A2'), -- don't (negative imperative particle)
  (212990, 'اُلَمپیک', 'A1', 'A2'), -- Olympic
  (212992, 'اَز نَظَرِ سیاسی', 'A1', 'A2'), -- politically
  (212995, 'اِمروزی', 'A1', 'A2'), -- today's / current
  (212997, 'به نَفعِ', 'A1', 'A2'), -- in favor of
  (213007, 'چَسبان', 'A2', 'B1'), -- self-adhesive
  (213008, 'مُبتَنی ساختَن', 'A2', 'B1'), -- to base (on)
  (213015, 'فَوق‌العاده', 'A2', 'B1'), -- exceptionally
  (213016, 'نیم‌سال', 'A2', 'B1'), -- semester
  (213024, 'مُتَمایِز بودَن', 'A2', 'B1'), -- to stand out / be distinct
  (213026, 'اُرتودُکس', 'A2', 'B1'), -- Orthodox
  (213027, 'کودَکانِه', 'A2', 'B1'), -- childish / children's
  (213038, 'گَردِشگَری', 'A2', 'B1'), -- touristic
  (213045, 'دیروزی', 'A2', 'B1'), -- yesterday's
  (213048, 'گازی', 'B1', 'B2'), -- gaseous
  (213049, 'تَحلیلی', 'B1', 'C1'), -- analytical / detailed
  (213050, 'بارگُذاری کَردَن', 'B1', 'B2'), -- to post / upload
  (213051, 'آنارشیست', 'B1', 'C1'), -- anarchist
  (213054, 'اُسقُفِ اَعظَم', 'B1', 'B2'), -- archbishop
  (213059, 'خودُرویی', 'B1', 'C1'), -- automotive / car-related
  (213061, 'شتاب دادَن', 'B1', 'B2'), -- to hurry (someone) / hasten
  (213063, 'آسیب رِساندَن', 'B1', 'C1'), -- to harm
  (213065, 'فُحش دادَن', 'B1', 'B2'), -- to curse / insult
  (213068, 'زَبانی', 'B1', 'B2'), -- linguistic
  (213069, 'جَنگَلی', 'B1', 'B2'), -- forest-related
  (213078, 'اِبراز کَردَن', 'B1', 'B2'), -- to manifest / express
  (213079, 'در مَعرَض قَرار گِرِفتَن', 'B1', 'B2'), -- to be exposed / exhibited
  (213080, 'رَوغَنِ زَیتون', 'B1', 'B2'), -- olive oil
  (213082, 'مُطَّلِع شُدَن', 'B1', 'B2'), -- to get informed / updated
  (213083, 'آکواریوم', 'B1', 'B2'), -- aquarium
  (213084, 'شِش‌ماهه', 'B1', 'C1'), -- six-month / semester-long
  (213086, 'کارآفرینی', 'B1', 'C1'), -- entrepreneurial / business-related
  (213088, 'قارِه', 'B1', 'B2'), -- continent
  (213089, 'شِکَست', 'B1', 'A2'), -- defeat
  (213092, 'رِضایَت‌بَخش', 'B1', 'C1'), -- satisfactory
  (213093, 'نِرخِ بَرابَری', 'B1', 'B2'), -- exchange rate / equivalence
  (213094, 'اَز نَظَرِ تاریخی', 'B1', 'B2'), -- historically
  (213095, 'زِندِگیِ روزَمَرّه', 'B1', 'B2'), -- everyday life
  (213096, 'نِشاندَن', 'B1', 'B2'), -- to seat (someone)
  (213101, 'اُمورِ عُمومی', 'B1', 'B2'), -- public affairs / commons
  (213102, 'بودجه اِختِصاصی', 'B1', 'B2'), -- budget line / earmarked fund
  (213105, 'تَحصیلاتِ تَکمیلی', 'B1', 'C1'), -- postgraduate
  (213107, 'یونانیِ نُوین', 'B1', 'C1'), -- Modern Greek
  (213108, 'اُستانی', 'B1', 'C1'), -- prefectural / provincial
  (213109, 'اَز نَظَرِ حُقوقی', 'B1', 'B2'), -- legally
  (213114, 'عید پاک', 'B1', 'B2'), -- Easter
  (213115, 'شاعِرانه', 'B1', 'B2'), -- poetic
  (213116, 'کیفی', 'B1', 'B2'), -- qualitative
  (213117, 'پیش اَز اِنتِخابات', 'B1', 'B2'), -- pre-election
  (213118, 'مُتَوَسِّل شُدَن', 'B1', 'B2'), -- to resort to / appeal to
  (213122, 'شَرط‌بَندی', 'B1', 'B2'), -- bet / wager
  (213125, 'به لِحاظِ مادّی', 'B1', 'B2'), -- materially
  (213129, 'دانِشجویی', 'B1', 'B2'), -- student-related
  (213130, 'بار زَدَن', 'B1', 'A2'), -- to load
  (213132, 'عَکّاسی', 'B1', 'B2'), -- photographic
  (213136, 'کریسمَسی', 'B1', 'B2'), -- Christmas-related
  (213137, 'جا شُدَن', 'B1', 'A2'), -- to fit
  (213138, 'دُروغ', 'B1', 'A2'), -- lie
  (213139, 'سَرمایِش', 'B1', 'C1'), -- refrigeration / cooling
  (213140, 'وَحشیانه', 'B2', 'C1'), -- wildly / fiercely
  (213141, 'قادِر نَبودَن', 'B2', 'C1'), -- to be unable
  (213143, 'بی‌حَرَکَت', 'B2', 'C1'), -- motionlessly
  (213144, 'بازساختاردِهی', 'B2', 'C1'), -- restructuring
  (213145, 'به‌طورِ مُفَصَّل', 'B2', 'C1'), -- in detail / analytically
  (213146, 'تَوسِعِه‌ای', 'B2', 'C1'), -- developmental
  (213147, 'یادشُدِه', 'B2', 'C1'), -- referred to / aforementioned
  (213149, 'به راحَتی', 'B2', 'C1'), -- comfortably
  (213150, 'مُعاوِنِ رَئیس', 'B2', 'C1'), -- vice president
  (213152, 'مُتَحَیِّر بودَن', 'B2', 'C1'), -- to wonder / be puzzled
  (213153, 'به‌طورِ مَنفی', 'B2', 'C1'), -- negatively
  (213154, 'اِعمال‌کُنَنده', 'B2', 'C1'), -- exercising / practicing
  (213155, 'بی‌سیم', 'B2', 'C1'), -- wireless
  (213157, 'مُعاف اَز مالیات', 'B2', 'C1'), -- tax-free
  (213158, 'شِکَنجه دادَن', 'B2', 'C1'), -- to torture / torment
  (213159, 'زِندِگی‌نامه‌ای', 'B2', 'C1'), -- biographical
  (213160, 'آبیِ روشَن', 'B2', 'C1'), -- light blue / azure
  (213161, 'مُعَلِّمِه', 'B2', 'C1'), -- female teacher
  (213162, 'رَوزنامه‌نِگاری', 'B2', 'C1'), -- journalistic
  (213163, 'گویِش', 'B2', 'C2'), -- dialect
  (213164, 'عُبور کَردَن اَز', 'B2', 'C1'), -- to cross
  (213166, 'بَرگُزاری', 'B2', 'C1'), -- conducting / holding (an event)
  (213167, 'مُدیرِ عامِل', 'B2', 'C1'), -- managing director
  (213168, 'داستانِ کوتاه', 'B2', 'C1'), -- short story
  (213169, 'دیکتاتوری', 'B2', 'C1'), -- dictatorship
  (213171, 'دَستِنامه', 'B2', 'C1'), -- handbook / manual
  (213172, 'ناسیونالیسم', 'B2', 'C2'), -- nationalism
  (213173, 'صَدُم', 'B2', 'C1'), -- hundredth (ordinal)
  (213174, 'اِنتِشاراتی', 'B2', 'C2'), -- publishing-related
  (213175, 'مَسئِلِه مُعَلَّق', 'B2', 'C1'), -- pending matter
  (213177, 'نوسازی', 'B2', 'C1'), -- modernization
  (213178, 'اِجرایی', 'B2', 'C1'), -- executive
  (213179, 'اَرتَجاعی', 'B2', 'C2'), -- elastic / flexible
  (213181, 'به‌طورِ غَیرِمُستَقیم', 'B2', 'C2'), -- indirectly
  (213182, 'آگاهی‌بَخش', 'B2', 'C1'), -- informative
  (213183, 'به‌طورِ یِکپارچه', 'B2', 'C1'), -- uniformly / as one
  (213184, 'اِمتِحانی', 'B2', 'C1'), -- examination-related / investigative
  (213185, 'یارانه دادَن', 'B2', 'C2'), -- to subsidize
  (213186, 'اَخبارِ روز', 'B2', 'C1'), -- current affairs / topicality
  (213187, 'مُناقِشِه‌بَرانگیز', 'B2', 'C1'), -- controversial / disputed
  (213188, 'اَز نَظَرِ عِلمی', 'B2', 'C1'), -- scientifically
  (213189, 'اِفتِخاری', 'B2', 'C1'), -- honorary
  (213191, 'نامِ تِجاری', 'B2', 'C1'), -- trade name / brand name
  (213192, 'آزمایِشگاهی', 'B2', 'C1'), -- laboratory-related
  (213195, 'طَرَفداری کَردَن اَز', 'B2', 'C1'), -- to favor
  (213196, 'اِداره مالیات', 'B2', 'C1'), -- tax office
  (213198, 'حَسادَت کَردَن', 'B2', 'C1'), -- to be jealous / envy
  (213200, 'فِدا کَردَن', 'B2', 'C1'), -- to sacrifice
  (213201, 'آرمان', 'B2', 'C1'), -- ideal
  (213202, 'ویژِگیِ خاص', 'B2', 'C1'), -- distinctiveness / peculiarity
  (213203, 'شَخصِ خُصوصی', 'B2', 'C1'), -- private individual
  (213204, 'به‌طورِ خُصوصی', 'B2', 'C1'), -- privately
  (213205, 'اُستادِ زَن', 'B2', 'C1'), -- female professor / teacher
  (213206, 'میخ کوبیدَن', 'B2', 'C1'), -- to nail / pin
  (213208, 'طَبَقه‌بَندی کَردَن', 'B2', 'C1'), -- to classify / rank
  (213209, 'قَهوه‌خانه', 'B2', 'C1'), -- coffee house
  (213211, 'سینِمایی', 'B2', 'C1'), -- cinematic
  (213212, 'شِکَمی', 'B2', 'C1'), -- abdominal
  (213213, 'پارلِمانی', 'B2', 'C1'), -- parliamentary
  (213214, 'کُمونیستی', 'B2', 'C1'), -- communist
  (213215, 'مورَب', 'B2', 'C2'), -- oblique / slanted
  (213216, 'مُتِأَسِّف بودَن', 'B2', 'C1'), -- to be sorry / feel sad
  (213217, 'اِستِعاری', 'B2', 'C2'), -- figurative / metaphorical
  (213218, 'دَفتَرِ ثَبت', 'B2', 'C1'), -- registry
  (213219, 'عایِق کَردَن', 'B2', 'C1'), -- to insulate / isolate
  (213220, 'به سَمتِ جُنوب', 'B2', 'C1'), -- southward
  (213223, 'طُغیان کَردَن', 'B2', 'C1'), -- to break out / burst out
  (213224, 'جادِه‌ای', 'B2', 'C2'), -- road-related
  (213225, 'به اِتِّفاقِ آرا', 'B2', 'C1'), -- unanimously
  (213226, 'در سَراسَرِ جَهان', 'B2', 'C1'), -- globally / worldwide
  (213227, 'آسیب‌شِناختی', 'B2', 'C1'), -- pathological
  (213228, 'بَد بَرداشت کَردَن', 'B2', 'C1'), -- to misunderstand
  (213230, 'مُراقَبَتِ پَزِشکی', 'B2', 'C1'), -- medical care
  (213231, 'اِعتِباری', 'B2', 'C1'), -- credit-related
  (213233, 'اَز نَظَرِ مَعنَوی', 'B2', 'C1'), -- spiritually / intellectually
  (213234, 'فوتبالی', 'B2', 'C1'), -- football-related
  (213235, 'بِه فِکر واداشتَن', 'B2', 'C2'), -- to trouble / give food for thought
  (213236, 'پیشنِهادی', 'B2', 'C1'), -- proposed / suggested
  (213237, 'پیش‌فَرض داشتَن', 'B2', 'C1'), -- to presuppose
  (213238, 'آتِش‌نِشانی', 'B2', 'C1'), -- fire-fighting
  (213239, 'خَیّاطی', 'B2', 'C1'), -- sewing / tailoring
  (213240, 'کِرکِره', 'B2', 'C1'), -- roller blind
  (213241, 'خَم شُدَن', 'B2', 'C1'), -- to bend down / stoop
  (213242, 'اِسپِرم', 'B2', 'C1'), -- sperm / seed
  (213243, 'اِسکان دادَن', 'B2', 'C1'), -- to house / shelter
  (213244, 'مَربوط به مَسکَن', 'B2', 'C1'), -- housing-related
  (213245, 'رواق', 'B2', 'C2'), -- arcade / portico
  (213246, 'تَألیف کَردَن', 'B2', 'C2'), -- to write / author (a book)
  (213247, 'مَشاوِره‌ای', 'B2', 'C2'), -- advisory / counseling
  (213248, 'سَندیکالیست', 'B2', 'C1'), -- trade unionist
  (213249, 'سَندیکایی', 'B2', 'C2'), -- trade union-related
  (213250, 'تَعاوُنی', 'B2', 'C1'), -- cooperative (organization)
  (213251, 'به‌طورِ سیستِماتیک', 'B2', 'C2'), -- systematically
  (213252, 'ذَبح کَردَن', 'B2', 'C2'), -- to slaughter
  (213253, 'فُلان', 'B2', 'C1'), -- so-and-so / such-and-such
  (213254, 'شومینه', 'B2', 'C1'), -- fireplace
  (213256, 'بانکی', 'B2', 'C1'), -- banking-related
  (213258, 'تابِع بودَن', 'B2', 'C1'), -- to fall under / be subordinate to
  (213259, 'مَشمول بودَن', 'B2', 'C2'), -- to be subject to
  (213260, 'کاهِشِ اَرزِش', 'B2', 'C1'), -- devaluation
  (213261, 'اِجباراً', 'B2', 'C2'), -- obligatorily
  (213262, 'مُعاوِنِ وَزیر', 'B2', 'C1'), -- deputy minister
  (213263, 'اِمسالی', 'B2', 'C2'), -- this year's
  (213264, 'اَدَبیّات‌شِناسی', 'B2', 'C1'), -- philology
  (213265, 'مالیاتی', 'B2', 'C1'), -- tax-related
  (213266, 'کِلاسِ تَقویَتی', 'B2', 'C2'), -- cram school / tutoring center
  (213267, 'بَرف می‌بارَد', 'B2', 'C2'), -- it is snowing
  (213269, 'به‌طوری‌که', 'B2', 'C1'), -- so that
  (213270, 'با مِهرَبانی', 'C1', 'C2'), -- kindly
  (213275, 'بی‌چون‌وچَرا', 'C1', 'C2'), -- indisputable
  (213279, 'کُنترَل‌نشُده', 'C1', 'C2'), -- uncontrolled
  (213280, 'آشکارساز', 'C1', 'C2'), -- detector
  (213281, 'قَطعِه‌یِ یَدَکی', 'C1', 'C2'), -- spare part
  (213282, 'کپی‌بَرداری', 'C1', 'C2'), -- copying
  (213283, 'پُمپاژ کَردَن', 'C1', 'C2'), -- to pump / draw (resources)
  (213284, 'مُطالِبه کَردَن', 'C1', 'C2'), -- to demand / claim
  (213285, 'بَعدِازظُهری', 'C1', 'C2'), -- afternoon-related
  (213288, 'غایِب بودَن', 'C1', 'C2'), -- to be absent
  (213289, 'غَیرِقابِلِ‌پیش‌بینی', 'C1', 'C2'), -- unpredictable
  (213291, 'باستان‌شِناس', 'C1', 'C2'), -- archaeologist
  (213292, 'مُعَطَّر', 'C1', 'C2'), -- aromatic
  (213293, 'نُقره‌ای', 'C1', 'C2'), -- made of silver
  (213294, 'آسم', 'C1', 'C2'), -- asthma
  (213295, 'غَیرِقابِلِ‌سازِش', 'C1', 'C2'), -- incompatible / uncompromising
  (213298, 'بِهینه‌سازی', 'C1', 'C2'), -- optimization
  (213299, 'کِتاب‌فُروشی', 'C1', 'C2'), -- bookstore
  (213300, 'پوشِشِ گیاهی', 'C1', 'C2'), -- vegetation
  (213304, 'گُربِه نَر', 'C1', 'C2'), -- tomcat
  (213305, 'تَعمیم دادَن', 'C1', 'C2'), -- to generalize
  (213308, 'وام‌گیری', 'C1', 'C2'), -- borrowing / lending
  (213309, 'نَظرسَنجی کَردَن', 'C1', 'C2'), -- to poll (opinion)
  (213310, 'تَشخیصی', 'C1', 'C2'), -- diagnostic
  (213312, 'تَغذیه‌ای', 'C1', 'C2'), -- nutritional
  (213313, 'بی‌زَمان', 'C1', 'C2'), -- timeless
  (213317, 'رِوایَت کَردَن', 'C1', 'C2'), -- to narrate
  (213319, 'توجیهی', 'C1', 'C2'), -- justificatory
  (213320, 'بِه قَتل رِساندَن', 'C1', 'C2'), -- to murder / assassinate
  (213322, 'ماهواره‌ای', 'C1', 'C2'), -- satellite-related
  (213323, 'مُؤَثِّر', 'C1', 'C2'), -- drastic / effective
  (213325, 'دائرِةُ‌المَعارِف', 'C1', 'C2'), -- encyclopedia
  (213327, 'ناسیونالیستی', 'C1', 'C2'), -- nationalistic
  (213329, 'دَرآمَدی', 'C1', 'C2'), -- income-related
  (213331, 'کُنترَل‌شُده', 'C1', 'C2'), -- controlled
  (213337, 'سَرمایِه‌گُذاری', 'C1', 'C2'), -- investment-related
  (213343, 'بُرجِ فَلَکی', 'C1', 'C2'), -- zodiac sign
  (213347, 'نیمه‌نِهایی', 'C1', 'C2'), -- semi-final
  (213355, 'اِمپریالیستی', 'C1', 'C2'), -- imperialist
  (213357, 'نِسبَتاً زیاد', 'C1', 'C2'), -- quite a lot of / several
  (213361, 'تَدوین کَردَن', 'C1', 'C2'), -- to draw up / compile
  (213363, 'قاطِعانه', 'C1', 'C2'), -- categorically
  (213365, 'تَهویه مُطبوع', 'C1', 'C2'), -- air conditioning
  (213367, 'جامِعه‌شِناسی', 'C1', 'C2'), -- sociology
  (213368, 'کُمونیسم', 'C1', 'C2'), -- communism
  (213370, 'بانگ زَدَن', 'C1', 'C2'), -- to caw / cry out
  (213371, 'کرواتی', 'C1', 'C2'), -- Croatian (person)
  (213373, 'نوسان داشتَن', 'C1', 'C2'), -- to fluctuate / range
  (213376, 'میانجیگَری کَردَن', 'C1', 'C2'), -- to mediate / intervene
  (213377, 'بوزوکی', 'C1', 'C2'), -- bouzouki (Greek instrument)
  (213379, 'جَوانانه', 'C1', 'C2'), -- youthful
  (213385, 'هَنگامِ سَحَر', 'C1', 'C2'), -- at dawn / daybreak
  (213387, 'هَمگَن', 'C1', 'C2'), -- homogeneous
  (213392, 'صَف‌آرایی کَردَن', 'C1', 'C2'), -- to line up / deploy (troops)
  (213394, 'اِنضِباطی', 'C1', 'C2'), -- disciplinary
  (213396, 'قَدَم‌زَدَن', 'C1', 'C2'), -- a walk / stroll
  (213397, 'پارسالی', 'C1', 'C2'), -- last year's
  (213398, 'نانِ پیتا', 'C1', 'C2'), -- pita bread
  (213399, 'به‌طورِ غَنی', 'C1', 'C2'), -- richly
  (213403, 'تَحریک‌آمیز', 'C1', 'C2'), -- provocative
  (213404, 'پرولِتاریا', 'C1', 'C2'), -- proletariat
  (213406, 'پَرَستِش کَردَن', 'C1', 'C2'), -- to worship / venerate
  (213407, 'سِبقَت گِرِفتَن', 'C1', 'C2'), -- to overtake / pass by
  (213408, 'پَریروز', 'C1', 'C2'), -- the day before yesterday
  (213414, 'تَکان‌دِهَنده', 'C1', 'C2'), -- shocking / stunning
  (213416, 'به صَرفه بودَن', 'C1', 'C2'), -- to be advantageous / profitable
  (213417, 'سِنتِتیک', 'C1', 'C2'), -- synthetic
  (213420, 'نَجات‌بَخش', 'C1', 'C2'), -- salutary / saving
  (213422, 'گاوِ نَر', 'C1', 'C2'), -- bull
  (213424, 'مُرَبَّعی', 'C1', 'C2'), -- square-shaped
  (213427, 'تِجلیلی', 'C1', 'C2'), -- honorary / commemorative
  (213428, 'آوازی', 'C1', 'C2'), -- sung / singable
  (213432, 'تَنَزُّل دادَن', 'C1', 'C2'), -- to downgrade
  (213433, 'پیراهَنِ ورزِشی', 'C1', 'C2'), -- jersey
  (213434, 'فاشیسم', 'C1', 'C2'), -- fascism
  (213435, 'فاشیستی', 'C1', 'C2'), -- fascist
  (213438, 'قابِلِ‌حَمل', 'C1', 'C2'), -- portable
  (213443, 'رَقصَندِه زَن', 'C1', 'C2'), -- female dancer
  (213450, 'بی‌سَر و صِدا', 'C2', 'C1'), -- silently / noiselessly
  (213451, 'جَمع زَدَن', 'C2', 'C1'), -- to sum up / add
  (213457, 'کَثافَت', 'C2', 'C1'), -- impurity / filth
  (213459, 'شِنیده شُدَن', 'C2', 'C1'), -- to be heard / to sound (like)
  (213466, 'دَفعِه دیگَر', 'C2', 'C1'), -- another time
  (213478, 'بازجویی کَردَن', 'C2', 'C1'), -- to interrogate
  (213486, 'به یاد آوَردَن', 'C2', 'C1'), -- to reminisce / recall fondly
  (213488, 'کَمی بالا بُردَن', 'C2', 'C1'), -- to raise slightly
  (213489, 'بِه‌هَم زَدَن', 'C2', 'C1'), -- to stir / rummage through
  (213497, 'اَحمَقانه', 'C2', 'C1'), -- foolishly
  (213508, 'اَرزِش داشتَن', 'C2', 'C1'), -- to be worth
  (213514, 'فِرِستاده', 'C2', 'C1'), -- envoy / delegate
  (213516, 'ساده کَردَن', 'C2', 'C1'), -- to simplify
  (213517, 'پیاده کَردَن', 'C2', 'C1'), -- to disembark (someone)
  (213523, 'بِه خواب رَفتَن', 'C2', 'C1'), -- to fall asleep
  (213524, 'بُریدِه', 'C2', 'C1'), -- clipping (newspaper)
  (213525, 'دور شُدَن', 'C2', 'C1'), -- to move away
  (213526, 'اَز هَم باز کَردَن', 'C2', 'C1'), -- to disassemble
  (213527, 'تَمام کَردَن', 'C2', 'C1'), -- to finish off
  (213528, 'خُداحافِظی کَردَن', 'C2', 'C1'), -- to bid farewell
  (213530, 'پَس زَدَن', 'C2', 'C1'), -- to repel / repress
  (213535, 'مَریض شُدَن', 'C2', 'C1'), -- to fall ill
  (213539, 'شوخی کَردَن', 'C2', 'C1'), -- to joke
  (213546, 'نابود شُدَن', 'C2', 'C1'), -- to be destroyed / vanish
  (213548, 'مَربوط به', 'C2', 'C1'), -- concerning
  (213559, 'بارون', 'C2', 'C1'), -- baron
  (213564, 'پیچ کَردَن', 'C2', 'C1'), -- to screw (in)
  (213569, 'راحَت شُدَن', 'C2', 'C1'), -- to make oneself comfortable / manage
  (213575, 'بو گِرِفتَن', 'C2', 'C1'), -- to stink
  (213577, 'گاییدَن', 'C2', 'C1'), -- to have sex (vulgar)
  (213582, 'لُخت کَردَن', 'C2', 'C1'), -- to undress (someone)
  (213588, 'غَذا خوردَن', 'C2', 'C1'), -- to have a meal / dine
  (213589, 'ماست', 'C2', 'C1'), -- yogurt
  (213593, 'سُر خوردَن', 'C2', 'C1'), -- to slip / slide
  (213594, 'آشنا شُدَن', 'C2', 'C1'), -- to get acquainted / meet each other
  (213595, 'گرَم', 'C2', 'C1'), -- gram
  (213600, 'سَریع‌تَر', 'C2', 'C1'), -- faster
  (213604, 'با تَوَجُّه به اینکه', 'C2', 'C1'), -- given that
  (213605, 'ده هِزار', 'C2', 'C1'), -- ten thousand
  (213607, 'دو هَفته', 'C2', 'C1'), -- fortnight
  (213608, 'دَهُم', 'C2', 'C1'), -- tenth
  (213616, 'دوشیزه', 'C2', 'C1'), -- Miss (title)
  (213617, 'ایجاد شُدَن', 'C2', 'C1'), -- to be created
  (213625, 'دَریافتَن', 'C2', 'C1'), -- to sense intuitively
  (213633, 'دَستور دادَن', 'C2', 'C1'), -- to order / command
  (213634, 'حِفظ شُدَن', 'C2', 'C1'), -- to be preserved / maintained
  (213636, 'نُفوذ کَردَن', 'C2', 'C1'), -- to penetrate / infiltrate
  (213637, 'بَرگُزار شُدَن', 'C2', 'C1'), -- to be conducted / take place
  (213639, 'عُبور کَردَن', 'C2', 'C1'), -- to pass through
  (213642, 'مالِ مَن', 'C2', 'C1'), -- mine / yours / etc (fem.)
  (213649, 'دوک', 'C2', 'C1'), -- duke
  (213662, 'به‌طورِ خاص', 'C2', 'C1'), -- more specifically
  (213665, 'مَعلوم اَست که', 'C2', 'C1'), -- it is known that
  (213667, 'وارِد شُدَن', 'C2', 'C1'), -- to be imported / admitted
  (213671, 'صَد هِزار', 'C2', 'C1'), -- hundred thousand
  (213674, 'راز گُفتَن', 'C2', 'C1'), -- to confide
  (213679, 'اِجرا شُدَن', 'C2', 'C1'), -- to be executed / carried out
  (213680, 'خود را بیان کَردَن', 'C2', 'C1'), -- to express oneself
  (213682, 'سُخنَرانی کَردَن', 'C2', 'C1'), -- to recite / deliver a speech
  (213683, 'بِسیار کَم', 'C2', 'C1'), -- minimally / very little
  (213694, 'فَعّال شُدَن', 'C2', 'C1'), -- to be activated
  (213706, 'اَز نَظَرِ حِرفه‌ای', 'C2', 'C1'), -- professionally
  (213707, 'تِکرار شُدَن', 'C2', 'C1'), -- to repeat itself / recur
  (213711, 'تأیید شُدَن', 'C2', 'C1'), -- to be confirmed
  (213712, 'سوار شُدَن', 'C2', 'C1'), -- boarding (transport)
  (213713, 'کُند کَردَن', 'C2', 'C1'), -- to slow down
  (213714, 'به‌طورِ خَطَرناک', 'C2', 'C1'), -- dangerously
  (213717, 'اِجازه داشتَن', 'C2', 'C1'), -- to be allowed / permitted
  (213723, 'حَتّی اَگَر', 'C2', 'C1'), -- even if
  (213738, 'گَرم شُدَن', 'C2', 'C1'), -- to warm oneself
  (213740, 'دَرخواست کَردَن', 'C2', 'C1'), -- to ask for / request
  (213742, 'رام', 'C2', 'C1'), -- tame / gentle
  (213744, 'آرام گِرِفتَن', 'C2', 'C1'), -- to calm down / rest
  (213746, 'غَذایِ دَریایی', 'C2', 'C1'), -- seafood
  (213747, 'به‌طورِ فَوق‌العاده', 'C2', 'C1'), -- wonderfully
  (213748, 'شیر دادَن', 'C2', 'C1'), -- to breastfeed
  (213750, 'ماده', 'C2', 'C1'), -- female (gender)
  (213751, 'ژاپُنی', 'C2', 'C1'), -- Japanese
  (213769, 'تَعیین شُدَن', 'C2', 'C1'), -- to be determined / defined
  (213772, 'شَب بِخِیر', 'C2', 'C1'), -- good night
  (213785, 'دَست به کار شُدَن', 'C2', 'C1'), -- to get down to / tackle a task
  (213788, 'بِه سَمتِ ... حَرکَت کَردَن', 'C2', 'C1'), -- to head towards
  (213791, 'واقِع بودَن', 'C2', 'C1'), -- to lie / be situated
  (213797, 'خود را نِگاه کَردَن', 'C2', 'C1'), -- to look at oneself
  (213800, 'نَزدیک شُدَن به', 'C2', 'C1'), -- to be about to / nearly
  (213813, 'بِرَق زَدَن', 'C2', 'C1'), -- to shine brightly
  (213815, 'آرزو کَردَن', 'C2', 'C1'), -- to long for / crave
  (213825, 'گیر کَردَن', 'C2', 'C1'), -- to get jammed
  (213832, 'سیاه کَردَن', 'C2', 'C1'), -- to blacken / tan
  (213835, 'بُزُرگ‌تَر', 'C2', 'C1'), -- bigger / older
  (213836, 'مِزه', 'C2', 'C1'), -- appetizer / meze
  (213838, 'رِسیدگی کَردَن', 'C2', 'C1'), -- to take care of / be concerned with
  (213839, 'در وَسَط', 'C2', 'C1'), -- in the middle
  (213847, 'اِجاره', 'C2', 'C1'), -- leasing
  (213848, 'سَرِانجام', 'C2', 'C1'), -- fatally / inevitably
  (213849, 'به‌مَحضِ اینکه', 'C2', 'C1'), -- as soon as
  (213865, 'اَه', 'C2', 'C1'), -- yuck!
  (213867, 'اِستِیک', 'C2', 'C1'), -- steak / chop
  (213868, 'جُلو', 'C2', 'C1'), -- in front / go ahead
  (213871, 'نازی', 'C2', 'C1'), -- Nazi (person)
  (213875, 'عَصَبی شُدَن', 'C2', 'C1'), -- to get irritated / annoyed
  (213881, 'پولی', 'C2', 'C1'), -- monetary
  (213886, 'نُت', 'C2', 'C1'), -- musical note
  (213891, 'لِباسِ خواب', 'C2', 'C1'), -- nightgown
  (213892, 'دوباره آمَدَن', 'C2', 'C1'), -- to come again
  (213893, 'دوباره اَنجام دادَن', 'C2', 'C1'), -- to do again
  (213895, 'جُدا کَردَن', 'C2', 'C1'), -- to unstick / detach
  (213902, 'خَلاص شُدَن اَز', 'C2', 'C1'), -- to get rid of
  (213903, 'جیغ زَدَن', 'C2', 'C1'), -- to scream / shriek
  (213906, 'اَز راهِ زَمینی', 'C2', 'C1'), -- by road
  (213916, 'نامِ کامِل', 'C2', 'C1'), -- full name
  (213921, 'دُرُستی', 'C2', 'C1'), -- correctness
  (213922, 'نِهایی کَردَن', 'C2', 'C1'), -- to finalize
  (213924, 'تا جایی که', 'C2', 'C1'), -- as much as / while
  (213926, 'در واقِع', 'C2', 'C1'), -- in essence
  (213932, 'عَجیب اینکه', 'C2', 'C1'), -- paradoxically
  (213935, 'کِنار زَدَن', 'C2', 'C1'), -- to push aside / set aside
  (213941, 'باکِره', 'C2', 'C1'), -- virgin (fem.)
  (213945, 'چاق شُدَن', 'C2', 'C1'), -- to gain weight
  (213947, 'مادَرِ هَمسَر', 'C2', 'C1'), -- mother-in-law
  (213948, 'خانواده هَمسَر', 'C2', 'C1'), -- in-laws
  (213952, 'مُراقَبَت کَردَن', 'C2', 'C1'), -- to care for / nurse
  (213957, 'به‌طورِ عالی', 'C2', 'C1'), -- splendidly / famously
  (213968, 'اِضافی', 'C2', 'C1'), -- redundant / surplus
  (213971, 'اِطِّلاعاتی', 'C2', 'C1'), -- informational
  (213978, 'صَندَلی راحَتی', 'C2', 'C1'), -- armchair
  (213984, 'کَمّی', 'C2', 'C1'), -- quantitative
  (213991, 'پیشرَفت کَردَن', 'C2', 'C1'), -- to prosper / get ahead
  (213993, 'بیش اَز هَمه', 'C2', 'C1'), -- above all
  (213995, 'تُست', 'C2', 'C1'), -- toast (drinking)
  (214005, 'رَئیسِ دانِشگاه', 'C2', 'C1'), -- university rector
  (214006, 'نَقشِ اَصلی را بازی کَردَن', 'C2', 'C1'), -- to star / play the lead role
  (214007, 'در دَرَجِه اَوَّل', 'C2', 'C1'), -- primarily
  (214015, 'کیسه', 'C2', 'C1'), -- bag / sack
  (214024, 'با قِطار', 'C2', 'C1'), -- by rail
  (214027, 'سُکوت کَردَن', 'C2', 'C1'), -- to remain silent
  (214028, 'گُه', 'C2', 'C1'), -- shit (vulgar)
  (214029, 'طَرح زَدَن', 'C2', 'C1'), -- to outline / sketch
  (214038, 'در خانه', 'C2', 'C1'), -- at home
  (214039, 'صاحِب‌خانه زَن', 'C2', 'C1'), -- landlady
  (214043, 'تَنگ کَردَن', 'C2', 'C1'), -- to narrow
  (214047, 'اَز نَظَرِ نِظامی', 'C2', 'C1'), -- militarily
  (214062, 'مُعامِله کَردَن', 'C2', 'C1'), -- to do business / transact
  (214073, 'تی کِشیدَن', 'C2', 'C1'), -- to mop
  (214074, 'ساکِت شُدَن', 'C2', 'C1'), -- to fall silent
  (214075, 'مُرَتَّب شُدَن', 'C2', 'C1'), -- to settle / get organized
  (214084, 'کارتِ تِلِفُن', 'C2', 'C1'), -- phone card
  (214086, 'عُنوان دادَن', 'C2', 'C1'), -- to title / entitle
  (214090, 'تُرک', 'C2', 'C1'), -- Turk
  (214091, 'تِپّه کَردَن', 'C2', 'C1'), -- to pile / mound up
  (214092, 'تِصادُف کَردَن', 'C2', 'C1'), -- to crash / collide
  (214095, 'سیُّم', 'C2', 'C1'), -- thirtieth
  (214124, 'کافی اَست', 'C2', 'C1'), -- that's enough / it suffices
  (214125, 'بیل زَدَن', 'C2', 'C1'), -- to shovel
  (214129, 'خوشحال بودَن', 'C2', 'C1'), -- to be glad / happy
  (214130, 'پایین آوَردَن', 'C2', 'C1'), -- to lower
  (214131, 'هَدیه دادَن', 'C2', 'C1'), -- to give as a gift
  (214132, 'خوشحال کَردَن', 'C2', 'C1'), -- to make happy
  (214136, 'ریدَن', 'C2', 'C1'), -- to shit (vulgar)
  (214137, 'دَستی', 'C2', 'C1'), -- manually-operated
  (214145, 'فُرو کَردَن', 'C2', 'C1'), -- to shove / stuff
  (214341, 'دورافتاده', 'B1', 'B2'), -- remote / distant
  (214342, 'تِک‌نوازی', 'C1', 'C2'), -- solo (music)
  (214347, 'هَدَررَفتِه', 'B1', 'C1') -- wasted / squandered
) AS v(id, written_form, old_level, new_level)
WHERE w.id = v.id
  AND w.language_id = (SELECT id FROM languages WHERE code = 'fa')
  AND w.written_form = v.written_form
  AND w.level = v.old_level;
