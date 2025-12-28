# CI/CD — Happy Path (wersja minimum) ✅

Ten wariant jest ułożony tak, żebyś przeszedł zadanie bez “min”:
- Jenkins w Dockerze ma **Node.js + npm + git + bash + rsync** już w obrazie.
- Pipeline w Jenkinsie działa bez agentów, bez docker.sock, bez kombinowania.

## Struktura
- `app/` — aplikacja Node + testy (Jest)
- `scripts/deploy_test.sh` — deploy do `deploy/test` + `DEPLOY_INFO.txt`
- `Jenkinsfile` — Checkout → Build → Test → Deploy
- `.gitlab-ci.yml` — build → test → deploy_test (deploy tylko na `main`)
- `Dockerfile.jenkins` + `docker-compose.jenkins.yml` — Jenkins z Node

---

# 0) Wymagania
- Docker Desktop uruchomiony (**Linux containers**)
- Git na Windows
- Konto GitHub/GitLab

---

# 1) Repozytorium (to MUSI być pierwsze)
## 1.1 Utwórz repo (GitHub/GitLab)
- Utwórz puste repo, skopiuj URL (HTTPS).

## 1.2 Push projektu (Windows CMD)
W katalogu projektu:

```bat
cd C:\Users\Kulson\Desktop\ci-cd-minimum
git init
git add .
git commit -m "Init"
git branch -M main
git remote add origin <URL_REPO>
git push -u origin main
```

**[SCREENSHOT 1]** Repo po pushu — widać `Jenkinsfile`, `.gitlab-ci.yml`, `Dockerfile.jenkins`.

---

# 2) Jenkins (Docker) — happy path
W katalogu repo:

```bat
docker compose -f docker-compose.jenkins.yml up -d --build
```

Sprawdź:
```bat
docker ps
```

Wejdź:
- http://localhost:8080

**[SCREENSHOT 2]** “Unlock Jenkins” (localhost:8080).

## 2.1 Hasło startowe
```bat
docker exec -it jenkins cat /var/jenkins_home/secrets/initialAdminPassword
```

**[SCREENSHOT 3]** Wklejenie hasła / odblokowanie.

## 2.2 Pluginy + admin
- Install suggested plugins
- Utwórz admina

**[SCREENSHOT 4]** Instalacja pluginów / tworzenie admina.

---

# 3) Jenkins Pipeline z Jenkinsfile
1. Jenkins → New Item
2. Nazwa: `ci-cd-minimum`
3. Typ: Pipeline
4. Pipeline → Definition: **Pipeline script from SCM**
5. SCM: **Git**
6. Repository URL: `<URL_REPO>`
7. Branches to build: `*/main`
8. Script Path: `Jenkinsfile`
9. Save

**[SCREENSHOT 5]** Konfiguracja joba (URL + `*/main` + Jenkinsfile).

## 3.1 Uruchom pipeline
- Build Now

**[SCREENSHOT 6]** Stage view / przebieg pipeline (zielone etapy).

## 3.2 Artifact z deploy
Build → Artifacts → `deploy/test/DEPLOY_INFO.txt`

**[SCREENSHOT 7]** Artifacts z `DEPLOY_INFO.txt`.

---

# 4) GitLab CI/CD (jeśli repo jest na GitLab)
- Push na `main` uruchomi pipeline automatycznie.
- CI/CD → Pipelines → kliknij pipeline → logi jobów.

**[SCREENSHOT 8]** Lista pipeline’ów.
**[SCREENSHOT 9]** Log joba `test`.
**[SCREENSHOT 10]** Artifacts joba `deploy_test` (deploy/test).

---

# 5) Webhook (opcjonalnie)
Minimum do zaliczenia: ręczne uruchomienie pipeline w Jenkins.
Jeśli prowadzący wymaga automatu:
- w Jenkins włącz “Poll SCM” (najprostsze)
- albo skonfiguruj webhook (zależnie od GitHub/GitLab)

**[SCREENSHOT 11]** (opcjonalny) ustawienia triggera/webhooka.

---

## Masz gotowy “happy path”.
Jeśli trzymasz się kolejności 1→2→3, to to przechodzi bez niespodzianek.
