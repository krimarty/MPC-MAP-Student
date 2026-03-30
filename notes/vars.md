# Přehled proměnných MPC-MAP

## `read_only_vars` — pouze ke čtení (nastavuje main)

| Pole | Typ | Popis |
|------|-----|-------|
| `.map` | struct | Mapa: `.walls`, `.goal`, `.limits`, `.gnss_denied`, `.goal_tolerance=0.5`, `.discretization_step=0.2` |
| `.discrete_map` | matrix | Diskretizovaná mapa pro path planning |
| `.agent_drive.type` | int | `2` = diferenciální pohon |
| `.agent_drive.interwheel_dist` | float | `0.2` m — rozchod kol |
| `.agent_drive.max_vel` | float | `1` m/s |
| `.lidar_config` | vector | Úhly LIDARu: `[0, 45, 90, 135, 180, 225, 270, 315]` rad |
| `.lidar_distances` | vector | Aktuální naměřené vzdálenosti LIDARem (8 hodnot) |
| `.gnss_position` | vector | Aktuální GNSS pozice (NaN v gnss_denied zónách) |
| `.gnss_history` | matrix | Historie všech GNSS měření |
| `.mocap_pose` | vector | Přesná pozice (jen pro debug, v ostrém hodnocení bude zakomentováno!) |
| `.sampling_period` | float | `0.1` s |
| `.max_particles` | int | `1000` |
| `.counter` | int | Číslo aktuální iterace (začíná od 1) |
| `.est_position_history` | matrix | Historie `estimated_pose` |
| `.measurement_distances` | — | (inicializováno prázdné) |

---

## `private_vars` — skryté před studentem (nastavuje/čte jen main)

| Pole | Popis |
|------|-------|
| `.agent_pose` | Skutečná pozice robota `[x, y, theta]` — **nikdy nečíst!** |
| `.raycasts` | Výsledky ray castů pro vizualizaci LIDARu |
| `.agent_position_history` | Historie skutečné pozice |

---

## `public_vars` — tvůj výstup (čteš i zapisuješ)

| Pole | Kdo nastavuje | Popis |
|------|---------------|-------|
| `.motion_vector` | `plan_motion()` | `[vR, vL]` — rychlosti kol, výchozí `[0, 0]` |
| `.estimated_pose` | `estimate_pose()` | Odhadnutá pozice `[x, y, theta]` |
| `.path` | `plan_path()` | Naplánovaná cesta, matice Nx2 `(x,y)` |
| `.particles` | PF funkce | Matice Nx3+ `(x, y, theta, ...)` |
| `.mu` | KF funkce | Střední hodnota stavu (KF) |
| `.sigma` | KF funkce | Kovarianční matice (KF) |
| `.kf.C` | `init_kalman_filter()` | Matice měření |
| `.kf.R` | `init_kalman_filter()` | Šum měření |
| `.kf.Q` | `init_kalman_filter()` | Šum procesu |
| `.init_iterations` | — | Počet init iterací (výchozí `1`) |
| `.pf_enabled` | — | Flag pro vizualizaci PF (výchozí `0`) |
| `.kf_enabled` | — | Flag pro vizualizaci KF (výchozí `0`) |

---

> **Klíčové omezení:** `private_vars.agent_pose` nikdy nepoužívat — to je skutečná pozice, robot ji "nezná".
> Pracuješ jen s `read_only_vars.lidar_distances`, `gnss_position` a svými odhady v `public_vars`.
