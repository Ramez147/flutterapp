# Tucky Setup-Anleitung

## Schnellstart

### 1. Repository klonen
```bash
git clone <repository-url>
cd tucky
```

### 2. Umgebungsvariablen einrichten

1. Kopiere die Beispiel-Datei:
```bash
cp .env.example .env
```

2. Öffne `.env` und fülle alle benötigten Variablen aus:

#### Gemini API-Schlüssel
- Gehe zu [Google AI Studio](https://makersuite.google.com/app/apikey)
- Erstelle einen neuen API-Schlüssel
- Füge ihn als `GEMINI_API_KEY` ein

#### Supabase
- Erstelle ein Projekt auf [Supabase](https://supabase.com)
- Kopiere die URL und den `anon` Key aus den Projekteinstellungen
- Füge sie als `SUPABASE_URL` und `SUPABASE_ANON_KEY` ein

#### Firebase
- Erstelle ein Projekt in der [Firebase Console](https://console.firebase.google.com/)
- Füge Apps für Web, Android und iOS hinzu
- Kopiere die jeweiligen API-Schlüssel und Konfigurationswerte
- Trage alle Werte in die `.env`-Datei ein

### 3. Supabase-Datenbank einrichten

Führe folgende SQL-Befehle in deinem Supabase SQL-Editor aus:

```sql
-- Profil Tabelle
CREATE TABLE profil (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id TEXT UNIQUE NOT NULL,
  name TEXT,
  email TEXT,
  address TEXT,
  postal_code TEXT,
  avatar_url TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Months Tabelle
CREATE TABLE months (
  id SERIAL PRIMARY KEY,
  user_id TEXT NOT NULL,
  month_name TEXT NOT NULL,
  budget DECIMAL(10, 2) NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Transaction Tabelle
CREATE TABLE transaction (
  id SERIAL PRIMARY KEY,
  month_id INTEGER REFERENCES months(id) ON DELETE CASCADE,
  user_id TEXT NOT NULL,
  amount DECIMAL(10, 2) NOT NULL,
  category TEXT NOT NULL,
  type TEXT NOT NULL,
  description TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Row Level Security aktivieren
ALTER TABLE profil ENABLE ROW LEVEL SECURITY;
ALTER TABLE months ENABLE ROW LEVEL SECURITY;
ALTER TABLE transaction ENABLE ROW LEVEL SECURITY;

-- Policies erstellen (Beispiel - anpassen nach Bedarf)
CREATE POLICY "Users can view their own profile" ON profil
  FOR SELECT USING (auth.uid()::text = user_id);

CREATE POLICY "Users can update their own profile" ON profil
  FOR UPDATE USING (auth.uid()::text = user_id);
```

### 4. Dependencies installieren
```bash
flutter pub get
```

### 5. App starten
```bash
# Development
flutter run

# Spezifische Plattform
flutter run -d chrome        # Web
flutter run -d android       # Android
flutter run -d ios           # iOS
```

## Produktion Build

### Android
```bash
flutter build apk --release
# oder
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
```

## Troubleshooting

### Problem: "API key not configured"
- Überprüfe, ob die `.env`-Datei im Hauptverzeichnis existiert
- Stelle sicher, dass `.env` in `pubspec.yaml` unter `assets` eingetragen ist
- Führe `flutter clean` und dann `flutter pub get` aus

### Problem: Firebase-Fehler
- Überprüfe, ob alle Firebase API-Schlüssel korrekt in `.env` eingetragen sind
- Stelle sicher, dass die Firebase-Konfiguration für deine Zielplattform vollständig ist
- Für Android: SHA-1 Fingerprint in Firebase Console hinterlegt?

### Problem: Supabase-Verbindungsfehler
- Überprüfe SUPABASE_URL und SUPABASE_ANON_KEY
- Stelle sicher, dass die Datenbanktabellen erstellt wurden
- Prüfe die Row Level Security Policies

## Sicherheitshinweise

⚠️ **Wichtig:**
- Committe **niemals** die `.env`-Datei mit echten Credentials
- Die `.env`-Datei ist bereits in `.gitignore` enthalten
- Teile API-Schlüssel nicht öffentlich
- Verwende für Produktion separate API-Schlüssel mit eingeschränkten Berechtigungen

## Weitere Hilfe

Bei Problemen:
1. Überprüfe die [Flutter Dokumentation](https://docs.flutter.dev/)
2. Siehe [Firebase Setup Guide](https://firebase.google.com/docs/flutter/setup)
3. Siehe [Supabase Flutter Guide](https://supabase.com/docs/guides/getting-started/quickstarts/flutter)
