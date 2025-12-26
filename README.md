# 📱 Tucky - KI-gestützte Finanz-App

## Über Tucky

Tucky ist eine moderne, plattformübergreifende Finanz-App für iOS, Android und Web. Die App ermöglicht es Nutzern, ihre persönlichen Finanzen intuitiv zu verwalten und mithilfe künstlicher Intelligenz wertvolle Einblicke in ihr Ausgabeverhalten zu erhalten.

### 🎯 Alleinstellungsmerkmale

- **KI-gestützte Finanzanalyse** durch Integration des Google Gemini 2.5 Flash Modells
- **Cross-Platform**: Eine Codebasis für iOS, Android und Web
- **Echtzeit-Synchronisation** aller Finanzdaten
- **Intuitive Datenvisualisierung** mit interaktiven Diagrammen

## 🛠️ Technologie-Stack

| Bereich | Technologie |
|---------|------------|
| Frontend Framework | Flutter & Dart |
| Authentifizierung | Firebase Authentication |
| Datenbank & Storage | Supabase (PostgreSQL) |
| KI-Engine | Google Gemini API (Gemini 2.5 Flash) |
| State Management | Provider Pattern |
| Datenvisualisierung | fl_chart |

## 🏗️ Architektur

### Modularer Aufbau

Die App folgt einer klaren Trennung zwischen Präsentations-, Geschäfts- und Datenschicht:

```
lib/
├── Drawer/                   # Navigation & System-Services
│   ├── EinstellungLayout/    # Theme- & Font-Management
│   ├── profilFolder/         # Profilverwaltung & Supabase-Integration
│   └── datei_open.dart       # Plattformübergreifende Datei-Downloads
├── Screens/
│   ├── Authentifications/    # Login & Registrierung (Firebase)
│   ├── ChatBot/              # KI-Assistent (Gemini)
│   └── new_budget/           # Budgetverwaltung & Visualisierung
└── models/                   # Datenstrukturen (Month, Transaction, Profil)
```

### Backend-Architektur

Tucky nutzt eine **Serverless-Architektur**:

1. **Firebase Authentication**: Sichere, token-basierte Benutzerauthentifizierung
2. **Supabase Client**: REST-API-Kommunikation mit PostgreSQL-Datenbank
3. **Chat Service**: Middleware zwischen Nutzer und Google Cloud AI

### Echtzeit-Reaktivität

Datenänderungen werden über **WebSocket-Verbindungen** (Supabase Realtime) automatisch synchronisiert. Der `ItemListProvider` stellt sicher, dass die UI (z.B. Kreisdiagramme) ohne manuellen Refresh aktualisiert wird.

## 💾 Datenmodell

Die Datenbank ist relational in Supabase aufgebaut:

| Tabelle | Primärschlüssel | Fremdschlüssel | Beschreibung |
|---------|----------------|----------------|--------------|
| **Profil** | id (UUID) | - | Benutzerprofil (Adresse, PLZ, Avatar) |
| **Months** | id (Integer) | - | Monatliche Budgetrahmen |
| **Transaction** | id (Integer) | monthId | Einzelne Transaktionen (Betrag, Kategorie, Typ) |

**Beziehungen**: 1:N zwischen Months und Transaction - jede Transaktion ist genau einem Monat zugeordnet.

## ⚙️ Hauptfunktionen

### 🤖 KI-Assistent (Gemini Integration)

Der KI-Assistent analysiert Finanzgewohnheiten und gibt personalisierte Empfehlungen.

**Implementierung** (`api_response.dart`):
- HTTP-POST-Request an Google Gemini API
- JSON-Serialisierung von Nutzeranfragen
- `CircularProgressIndicator` für optimale UX während der API-Latenz

### 📁 Plattformübergreifendes Datei-Handling

**Implementierung** (`datei_open.dart`):
- **Web**: AnchorElement-Blob für Browser-Downloads
- **Mobile**: `path_provider` für lokalen Dateisystem-Zugriff
- Automatische Plattform-Erkennung und entsprechende Handhabung

### 🎨 Dynamische Personalisierung

- **Theme Management**: Anpassbare Schriftgrößen und Farbschemata
- **Live-Visualisierung**: `fl_chart` wandelt Transaktionsdaten in interaktive Echtzeit-Diagramme um
- **Responsive Design**: Optimiert für alle Bildschirmgrößen

## 🔒 Sicherheit & Datenschutz

### Authentifizierung

Der `AuthGate` stellt sicher, dass geschützte Bereiche nur mit gültigem Firebase-Token zugänglich sind.

### DSGVO-Konformität

- **Account-Löschung**: Vollständige Löschung über `profil_delete.dart`
- **Datenlöschung**: Firebase- und Supabase-Daten werden entfernt
- **Empfehlung**: PostgreSQL CASCADE DELETE für automatische Bereinigung verknüpfter Daten

### API-Sicherheit

✅ **Implementiert**: Alle API-Schlüssel sind sicher in `.env`-Datei ausgelagert

Die App verwendet `flutter_dotenv` für sichere Verwaltung von Umgebungsvariablen:

```dart
// Sichere Implementierung
static final String apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
```

**Wichtig**: Die `.env`-Datei ist in `.gitignore` enthalten und wird nicht in die Versionskontrolle eingecheckt.

## 🚀 Installation & Deployment

### Voraussetzungen

- Flutter SDK (neueste stabile Version)
- Firebase-Konto
- Supabase-Konto
- Google Gemini API-Schlüssel

### Setup-Schritte

#### 1. Umgebungsvariablen konfigurieren
```bash
# Kopiere die Beispiel-.env-Datei
cp .env.example .env

# Bearbeite .env und füge deine eigenen API-Schlüssel ein
# - GEMINI_API_KEY
# - SUPABASE_URL und SUPABASE_ANON_KEY
# - Firebase API-Schlüssel für alle Plattformen
```

⚠️ **Wichtig**: Teile niemals deine `.env`-Datei oder committe sie in Git!

#### 2. Firebase Setup
```bash
# App in Firebase Console registrieren
# SHA-1 Fingerprints für Android hinzufügen
```

#### 3. Supabase Setup
Erstellen Sie folgende Tabellen in Ihrer Supabase-Datenbank:
- `profil` (Benutzerdaten)
- `months` (Budgetrahmen)
- `transaction` (Transaktionen)

#### 4. Dependencies installieren
```bash
flutter pub get
```

#### 5. Build
```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release

# Web
flutter build web
```

### Wichtige Dependencies

```yaml
dependencies:
  supabase_flutter: ^latest    # Datenbank-Kommunikation
  firebase_auth: ^latest        # Authentifizierung
  fl_chart: ^latest             # Datenvisualisierung
  image_picker: ^latest         # Kamera & Galerie
  provider: ^latest             # State Management
  flutter_dotenv: ^latest       # Umgebungsvariablen
```

### Umgebungsvariablen

Die App benötigt eine `.env`-Datei im Hauptverzeichnis mit folgenden Variablen:

```env
# Gemini API
GEMINI_API_KEY=your_gemini_api_key

# Supabase
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_supabase_anon_key

# Firebase (für alle Plattformen)
FIREBASE_WEB_API_KEY=...
FIREBASE_ANDROID_API_KEY=...
FIREBASE_IOS_API_KEY=...
# ... weitere Firebase-Konfigurationen
```

Eine vollständige Vorlage finden Sie in [.env.example](.env.example).

### Docker-Nutzung

#### Image pullen

```bash
docker pull ramez147/tucky:latest
```

#### Image Details

- **Repository**: ramez147/tucky
- **Tag**: latest (oder spezifische Version wie v1.0)
- **Docker Hub**: https://hub.docker.com/r/ramez147/tucky

## 📊 Ausblick & zukünftige Features

Tucky bietet eine solide Grundlage für moderne Finanzverwaltung. Die klare Trennung zwischen Authentifizierung (Firebase) und Datenhaltung (Supabase) ermöglicht hohe Skalierbarkeit.

### Geplante Erweiterungen

- 🔍 **OCR-Belegerkennung**: Automatische Extraktion von Transaktionsdaten aus Fotos
- 📈 **Erweiterte Analytics**: Detaillierte Finanzprognosen und Trends
- 🌐 **Multi-Währungsunterstützung**: Verwaltung verschiedener Währungen
- 🔔 **Smart Notifications**: KI-basierte Ausgabenwarnungen

---

## 👨‍💻 Entwickler

Derbali Ramez: [GitHub](https://github.com/Ramez147)

**Entwickelt mit ❤️ und Flutter**