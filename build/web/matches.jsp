<!DOCTYPE html>
<html lang="en">

<head>
    <%@ include file="/common/head.jsp" %>

    <!-- Dashboard-specific styles -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/matchesCSS.css">
</head>

<body>

    <%@ include file="/components/navbar.jsp" %>

    <main class="main-content">

        <%@ include file="/components/header.jsp" %>

        <section id="matches" class="section">

            <h2>Matches</h2>
            <p class="hint section-lead">
                Filter fixtures by sport and league; open a row for live controls below.
            </p>

            <div class="card card--tinted matches-hub">

                <div class="matches-toolbar">

                    <div class="matches-toolbar__field">
                        <label for="list-sport">Sport</label>

                        <select id="list-sport" name="sport"
                                aria-label="Filter matches by sport">

                            <option value="all">All sports</option>
                            <option value="football" selected>Football</option>
                            <option value="basketball">Basketball</option>
                            <option value="badminton">Badminton</option>
                            <option value="volleyball">Volleyball</option>
                            <option value="futsal">Futsal</option>

                        </select>
                    </div>

                    <div class="matches-toolbar__field matches-toolbar__field--grow">

                        <label for="list-league">League / competition</label>

                        <select id="list-league" name="league"
                                aria-label="Filter matches by league">

                            <option value="all">All in sport</option>

                            <option value="liga-premier"
                                    data-sport="football"
                                    selected>
                                Football ? Liga Premier
                            </option>

                            <option value="futsal-cup"
                                    data-sport="futsal">
                                Futsal Cup
                            </option>

                            <option value="bb-campus"
                                    data-sport="basketball">
                                Basketball Campus League
                            </option>

                            <option value="bad-open"
                                    data-sport="badminton">
                                Badminton Open
                            </option>

                            <option value="vb-challenge"
                                    data-sport="volleyball">
                                Volleyball Challenge
                            </option>

                        </select>
                    </div>

                </div>

                <ul class="matches-list" id="matches-list">

                    <!-- Match 1 -->
                    <li class="matches-list__item"
                        data-sport="football"
                        data-league="liga-premier">

                        <div class="matches-list__when">
                            14 May · 20:30 · Stadium A
                        </div>

                        <div class="matches-list__main">
                            <span class="matches-list__team">FSKM</span>

                            <span class="matches-list__score">
                                <strong>2</strong> ?
                                <strong>1</strong>
                            </span>

                            <span class="matches-list__team">Engineering</span>
                        </div>

                        <div class="matches-list__meta">
                            <span>Football · Liga Premier</span>
                            <span class="matches-list__round">QF</span>
                            <span class="status-pill status-pill--live">Live</span>
                        </div>

                        <button type="button"
                                class="btn btn--sm btn--ghost matches-list__open">
                            Open
                        </button>

                    </li>

                    <!-- Match 2 -->
                    <li class="matches-list__item"
                        data-sport="football"
                        data-league="liga-premier">

                        <div class="matches-list__when">
                            18 May · 16:00 · Stadium B
                        </div>

                        <div class="matches-list__main">
                            <span class="matches-list__team">Science</span>
                            <span class="matches-list__score">?</span>
                            <span class="matches-list__team">Law</span>
                        </div>

                        <div class="matches-list__meta">
                            <span>Football · Liga Premier</span>
                            <span class="matches-list__round">League</span>
                            <span class="status-pill">Scheduled</span>
                        </div>

                        <button type="button"
                                class="btn btn--sm btn--ghost matches-list__open">
                            Open
                        </button>

                    </li>

                    <!-- Match 3 -->
                    <li class="matches-list__item"
                        data-sport="basketball"
                        data-league="bb-campus">

                        <div class="matches-list__when">
                            15 May · 17:00 · Indoor 2
                        </div>

                        <div class="matches-list__main">
                            <span class="matches-list__team">Business</span>
                            <span class="matches-list__score">?</span>
                            <span class="matches-list__team">Science</span>
                        </div>

                        <div class="matches-list__meta">
                            <span>Basketball · Campus League</span>
                            <span class="matches-list__round">League</span>
                            <span class="status-pill">Scheduled</span>
                        </div>

                        <button type="button"
                                class="btn btn--sm btn--ghost matches-list__open">
                            Open
                        </button>

                    </li>

                    <!-- Match 4 -->
                    <li class="matches-list__item"
                        data-sport="badminton"
                        data-league="bad-open">

                        <div class="matches-list__when">
                            15 May · 19:30 · Hall B
                        </div>

                        <div class="matches-list__main">
                            <span class="matches-list__team">FSKM (S)</span>

                            <span class="matches-list__score">
                                <strong>2</strong> ?
                                <strong>0</strong>
                            </span>

                            <span class="matches-list__team">
                                Engineering (S)
                            </span>
                        </div>

                        <div class="matches-list__meta">
                            <span>Badminton · Open</span>
                            <span class="matches-list__round">QF</span>
                            <span class="status-pill status-pill--done">FT</span>
                        </div>

                        <button type="button"
                                class="btn btn--sm btn--ghost matches-list__open">
                            Open
                        </button>

                    </li>

                    <!-- Match 5 -->
                    <li class="matches-list__item"
                        data-sport="volleyball"
                        data-league="vb-challenge">

                        <div class="matches-list__when">
                            16 May · 16:00 · Main court
                        </div>

                        <div class="matches-list__main">
                            <span class="matches-list__team">FPA</span>
                            <span class="matches-list__score">?</span>
                            <span class="matches-list__team">FSSR</span>
                        </div>

                        <div class="matches-list__meta">
                            <span>Volleyball · Challenge</span>
                            <span class="matches-list__round">MD6</span>
                            <span class="status-pill">Scheduled</span>
                        </div>

                        <button type="button"
                                class="btn btn--sm btn--ghost matches-list__open">
                            Open
                        </button>

                    </li>

                    <!-- Match 6 -->
                    <li class="matches-list__item"
                        data-sport="futsal"
                        data-league="futsal-cup">

                        <div class="matches-list__when">
                            16 May · 21:00 · Futsal 1
                        </div>

                        <div class="matches-list__main">
                            <span class="matches-list__team">Law</span>

                            <span class="matches-list__score">
                                <strong>4</strong> ?
                                <strong>4</strong>
                            </span>

                            <span class="matches-list__team">Architecture</span>
                        </div>

                        <div class="matches-list__meta">
                            <span>Futsal · Cup</span>
                            <span class="matches-list__round">Group C</span>
                            <span class="status-pill status-pill--done">FT</span>
                        </div>

                        <button type="button"
                                class="btn btn--sm btn--ghost matches-list__open">
                            Open
                        </button>

                    </li>

                </ul>

                <p class="hint matches-list-empty"
                   id="matches-list-empty"
                   hidden>
                    No fixtures for this sport and league.
                </p>

            </div>

            <!-- Live Controls -->
            <h3 class="matches-live-heading">
                Live match controls (storyboard)
            </h3>

            <p class="hint" style="margin-bottom:14px">
                Same screen you use during a live game:
                events, bench, timeline.
            </p>

            <div class="card large card--tinted">

                <h3>Match event controls</h3>

                <p class="hint" style="margin-bottom:16px">
                    Team sports (football, futsal, basketball, volleyball):
                    substitutions, cards, and bench.
                    Racket sports: events only ? no bench.
                </p>

                <div class="button-group">

                    <button type="button">Add goal</button>
                    <button type="button">Add assist</button>
                    <button type="button">Yellow card</button>
                    <button type="button">Red card</button>
                    <button type="button">Substitution</button>

                    <button type="button"
                            class="btn btn--gold">
                        Player injury
                    </button>

                </div>

                <div class="match-layout">

                    <!-- Active Players -->
                    <div class="lineup-panel">

                        <h4>On pitch / court ? FSKM</h4>

                        <div class="player-chip">
                            Ahmad <span>#10 · FW</span>
                        </div>

                        <div class="player-chip">
                            Daniel <span>#7 · MF</span>
                        </div>

                        <div class="player-chip">
                            Faris <span>#9 · FW</span>
                        </div>

                        <div class="player-chip">
                            Ikram <span>#4 · DF</span>
                        </div>

                        <p class="hint">
                            Storyboard: extend to full starting lineup
                            per sport rules.
                        </p>

                    </div>

                    <!-- Bench -->
                    <div class="lineup-panel lineup-panel--bench">

                        <h4>Bench ? FSKM</h4>

                        <div class="player-chip">
                            Hakim <span>#14</span>
                        </div>

                        <div class="player-chip">
                            Syafiq <span>#22</span>
                        </div>

                        <div class="player-chip">
                            Luqman <span>#18</span>
                        </div>

                        <p class="hint">
                            Drag-to-substitute or pick from bench
                            in the live match UI.
                        </p>

                    </div>

                </div>

                <p class="hint hint--gold" style="margin-top:20px">

                    <strong>Badminton / tennis:</strong>
                    no bench ? show only the two (or four for doubles)
                    active names and match points.
                    Injury still logged for medical
                    and eligibility records.

                </p>

                <!-- Injury Timeline -->
                <h3 style="margin-top:28px">
                    Injury log (this match)
                </h3>

                <ul class="timeline">
                    <li>
                        34? Injury ? Daniel (ankle);
                        assessed, continued
                    </li>
                </ul>

                <!-- Match Timeline -->
                <h3 style="margin-top:24px">
                    Event timeline
                </h3>

                <ul class="timeline">
                    <li>12? Goal ? Ahmad</li>
                    <li>26? Yellow card ? Daniel</li>
                    <li>40? Substitution ? Hakim on for Luqman</li>
                    <li>77? Goal ? Faris</li>
                </ul>

            </div>

        </section>

    </main>

</body>

</html>