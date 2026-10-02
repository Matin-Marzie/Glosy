<div align="center">

# Glosy

### Developing a Mobile-Assisted Language Learning Application Utilizing Short-Form Video Reels and Hypercasual Games

*BSc Thesis · Ionian University*

[![Thesis PDF](https://img.shields.io/badge/Thesis-PDF-B31B1B?style=for-the-badge&logo=adobeacrobatreader&logoColor=white)](manuscript/thesis.pdf)
[![Download APK](https://img.shields.io/badge/Download-APK-3DDC84?style=for-the-badge&logo=android&logoColor=white)](https://github.com/Matin-Marzie/bsc_thesis_ionian_university/releases/latest/download/app-release.apk)

[![CC BY-NC-SA 4.0](https://licensebuttons.net/l/by-nc-sa/4.0/88x31.png)](https://creativecommons.org/licenses/by-nc-sa/4.0/)

</div>

---

## 🔗 Links

| Resource | Link |
| --- | --- |
| 📄 Thesis (PDF) | [manuscript/thesis.pdf](manuscript/thesis.pdf) |
| 📱 Android releases | [Releases page](https://github.com/Matin-Marzie/bsc_thesis_ionian_university/releases/latest) |

## 📱 Download the App (Android)

Grab the APK from the badge above or from the [Releases page](https://github.com/Matin-Marzie/bsc_thesis_ionian_university/releases/latest).

Open the link on your phone, download the APK, and install it.

> [!NOTE]
> You may need to allow installs from your browser/file manager in Android's settings.

## 🧰 Prerequisites

- Node.js 18+ & npm
- Python 3.11+ (for the reels service)
- PostgreSQL 18
- Git

## 📥 Clone the Repository

```bash
git clone https://github.com/Matin-Marzie/bsc_thesis_ionian_university
cd bsc_thesis_ionian_university
```

## 🗄️ Database Setup

Create the database and user, then load the schema and data:

```bash
# Create user and database (defaults used by the backend and reels service)
sudo -u postgres psql -c "CREATE USER root WITH PASSWORD '1234';"
sudo -u postgres psql -c "CREATE DATABASE thesis_db OWNER root;"

# Load schema, then data
psql -h localhost -U root -d thesis_db -f database/glosy_structure.sql
psql -h localhost -U root -d thesis_db -f database/glosy_data.sql
```

> [!NOTE]
> The dumps already include every migration in `database/migrations/`, and they need PostgreSQL 18's `psql` to load.

The backend reads its database settings from `backend/.env` (`DB_HOST`, `DB_PORT`, `DB_NAME`, `DB_USER`, `DB_PASSWORD`).

## 🖥️ Backend Setup

```bash
# Navigate to backend directory
cd backend

# Install dependencies
npm install

# Start development server
npm run dev
```

- Backend: `http://localhost:3500`
- API documentation: `http://localhost:3500/api-docs`

## 🎬 Reels Service Setup

Requires Python 3.11+ and a running PostgreSQL database:

```bash
# Navigate to reels-service directory
cd ../reels-service

# Create and activate a virtual environment
python3 -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Start development server
python3 main.py
```

- Reels service: `http://localhost:3600`
- API documentation: `http://localhost:3600/docs`

## 📲 Frontend Setup

```bash
# Navigate to frontend directory
cd ../frontend

# Install dependencies
npm install

# Start development server
npx expo start
```

Follow the prompts to run on an Android emulator, iOS simulator, or a device via Expo Go.

## 🗂️ Project Structure

```
bsc_thesis_ionian_university/
├── backend/          # Node.js/Express API
├── frontend/         # React Native (Expo) app
├── reels-service/    # Python reels recommendation service
├── database/         # PostgreSQL schema & data
├── manuscript/       # LaTeX source of the thesis
└── scripts/          # Evaluation scripts
```

## 📖 API Documentation

Visit `http://localhost:3500/api-docs` for full Swagger API documentation.

## 📜 License

This work is licensed under a [Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License](https://creativecommons.org/licenses/by-nc-sa/4.0/).
