<!DOCTYPE html>
<html lang="en">

<head>
    <%@ include file="/common/head.jsp" %>
    <!-- Dashboard-specific styles -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/dashboardCSS.css">
</head>

<body>

    <%@ include file="/components/navbar.jsp" %>

    <main class="main-content">

        <%@ include file="/components/header.jsp" %>

        <section id="dashboard" class="section">
            <h2>Dashboard</h2>

            <div class="dashboard-stack">

                <!-- ?? Toolbar ?????????????????????????????? -->
                <div class="dashboard-toolbar card card--tinted">
                    <div class="dashboard-toolbar__row dashboard-toolbar__row--filters">

                        <div class="dashboard-toolbar__field">
                            <label class="dashboard-toolbar__label" for="dash-sport">Sport</label>
                            <select id="dash-sport" aria-label="Choose sport">
                                <option value="football" selected>Football</option>
                                <option value="basketball">Basketball</option>
                                <option value="badminton">Badminton</option>
                                <option value="volleyball">Volleyball</option>
                                <option value="tennis">Tennis</option>
                                <option value="futsal">Futsal</option>
                            </select>
                        </div>

                        <div class="dashboard-toolbar__field">
                            <label class="dashboard-toolbar__label" for="dash-competition">Competition</label>
                            <select id="dash-competition" aria-label="Choose competition">
                                <option value="liga-premier"         data-sport="football"   selected>Liga Kampus ? Football Premier</option>
                                <option value="inter-faculty-futsal" data-sport="futsal"             >Inter-Faculty Futsal Cup</option>
                                <option value="badminton-open"       data-sport="badminton"          >Badminton Open</option>
                                <option value="basketball-campus"    data-sport="basketball"         >Basketball Campus League</option>
                                <option value="volleyball-challenge" data-sport="volleyball"         >Volleyball Challenge</option>
                                <option value="tennis-open"          data-sport="tennis"             >Tennis Open (Campus)</option>
                            </select>
                        </div>

                        <button type="button" class="btn btn--primary btn--sm dashboard-toolbar__cta">
                            + Schedule match
                        </button>
                    </div>
                    <p class="dashboard-toolbar__hint hint">
                        Sport and competition filter the fixture list and league table below.
                    </p>
                </div>

                <!-- ?? Leagues + Featured Live ????????????? -->
                <div class="dashboard-columns">

                    <!-- Leagues -->
                    <div class="card card--accent-top card--tinted">
                        <h3>Leagues</h3>
                        <ul class="league-list">

                            <li class="league-list__item">
                                <div class="league-list__main">
                                    <strong>Liga Kampus ? Football Premier</strong>
                                    <span class="badge">Football</span>
                                </div>
                                <div class="league-list__meta">12 teams · League + knockout · Ends 28 Jun</div>
                                <div class="league-list__foot">
                                    <span class="league-list__phase">Knockout: R16</span>
                                    <button type="button" class="btn btn--sm btn--ghost">Open</button>
                                </div>
                            </li>

                            <li class="league-list__item">
                                <div class="league-list__main">
                                    <strong>Inter-Faculty Futsal Cup</strong>
                                    <span class="badge badge--gold">Futsal</span>
                                </div>
                                <div class="league-list__meta">8 teams · Group + semis · Ends 12 Jul</div>
                                <div class="league-list__foot">
                                    <span class="league-list__phase">Group stage</span>
                                    <button type="button" class="btn btn--sm btn--ghost">Open</button>
                                </div>
                            </li>

                            <li class="league-list__item">
                                <div class="league-list__main">
                                    <strong>Badminton Open (Singles / Doubles)</strong>
                                    <span class="badge">Badminton</span>
                                </div>
                                <div class="league-list__meta">16 faculties · Swiss + bracket</div>
                                <div class="league-list__foot">
                                    <span class="league-list__phase">Quarter-finals</span>
                                    <button type="button" class="btn btn--sm btn--ghost">Open</button>
                                </div>
                            </li>

                            <li class="league-list__item">
                                <div class="league-list__main">
                                    <strong>Volleyball Challenge</strong>
                                    <span class="badge">Volleyball</span>
                                </div>
                                <div class="league-list__meta">10 teams · Round robin</div>
                                <div class="league-list__foot">
                                    <span class="league-list__phase">Matchday 6</span>
                                    <button type="button" class="btn btn--sm btn--ghost">Open</button>
                                </div>
                            </li>

                        </ul>
                    </div>

                    <!-- Featured Live -->
                    <div class="card card--purple card--tinted">
                        <h3>Featured live</h3>
                        <p>FSKM vs Engineering · Football knockout</p>
                        <p class="live-score">2 ? 1</p>
                        <p>78? · <span class="live-tag">LIVE</span></p>
                        <p class="hint" style="margin-top:4px">
                            Pin any match here; full controls are under <strong>Matches</strong>.
                        </p>
                    </div>

                </div><!-- /.dashboard-columns -->

                <!-- ?? Fixture list ????????????????????????? -->
                <div class="card large card--tinted dashboard-matches-card">
                    <h3 class="dashboard-matches-card__title" id="dash-matches-heading">
                        Liga Kampus ? Football Premier
                    </h3>
                    <p class="hint dashboard-matches-card__intro" id="dash-matches-sub">
                        Fixtures for this competition. Each row shows stage and match number.
                    </p>

                    <ul class="dash-matches-list" id="dash-matches-list" aria-label="Competition fixtures">

                        <li class="dash-match-card">
                            <div class="fixture-labels">
                                <span class="fixture-type fixture-type--knockout">Quarter-final</span>
                                <span class="fixture-match-no">Match 1</span>
                            </div>
                            <div class="dash-match-card__body">
                                <div class="matches-list__when">14 May · 20:30 · Stadium A</div>
                                <div class="matches-list__main">
                                    <span class="matches-list__team">FSKM</span>
                                    <span class="matches-list__score"><strong>2</strong> ? <strong>1</strong></span>
                                    <span class="matches-list__team">Engineering</span>
                                </div>
                                <div class="matches-list__meta">
                                    <span class="status-pill status-pill--live">Live</span>
                                </div>
                                <button type="button" class="btn btn--sm btn--ghost">Open</button>
                            </div>
                        </li>

                        <li class="dash-match-card">
                            <div class="fixture-labels">
                                <span class="fixture-type fixture-type--league">League</span>
                                <span class="fixture-match-no">Match 12</span>
                            </div>
                            <div class="dash-match-card__body">
                                <div class="matches-list__when">18 May · 16:00 · Stadium B</div>
                                <div class="matches-list__main">
                                    <span class="matches-list__team">Science</span>
                                    <span class="matches-list__score">?</span>
                                    <span class="matches-list__team">Law</span>
                                </div>
                                <div class="matches-list__meta">
                                    <span class="status-pill">Scheduled</span>
                                </div>
                                <button type="button" class="btn btn--sm btn--ghost">Open</button>
                            </div>
                        </li>

                        <li class="dash-match-card">
                            <div class="fixture-labels">
                                <span class="fixture-type fixture-type--league">Group stage</span>
                                <span class="fixture-match-no">MD 6</span>
                            </div>
                            <div class="dash-match-card__body">
                                <div class="matches-list__when">17 May · 16:00 · Main court</div>
                                <div class="matches-list__main">
                                    <span class="matches-list__team">FPA</span>
                                    <span class="matches-list__score">?</span>
                                    <span class="matches-list__team">FSSR</span>
                                </div>
                                <div class="matches-list__meta">
                                    <span class="status-pill">Scheduled</span>
                                </div>
                                <button type="button" class="btn btn--sm btn--ghost">Open</button>
                            </div>
                        </li>

                        <li class="dash-match-card">
                            <div class="fixture-labels">
                                <span class="fixture-type fixture-type--knockout">Quarter-final</span>
                                <span class="fixture-match-no">Match 2</span>
                            </div>
                            <div class="dash-match-card__body">
                                <div class="matches-list__when">19 May · 19:00 · Stadium A</div>
                                <div class="matches-list__main">
                                    <span class="matches-list__team">Business</span>
                                    <span class="matches-list__score">?</span>
                                    <span class="matches-list__team">Education</span>
                                </div>
                                <div class="matches-list__meta">
                                    <span class="status-pill">Scheduled</span>
                                </div>
                                <button type="button" class="btn btn--sm btn--ghost">Open</button>
                            </div>
                        </li>

                        <li class="dash-match-card">
                            <div class="fixture-labels">
                                <span class="fixture-type fixture-type--cup">Semi-final</span>
                                <span class="fixture-match-no">Match 19</span>
                            </div>
                            <div class="dash-match-card__body">
                                <div class="matches-list__when">28 May · 21:00 · Stadium A</div>
                                <div class="matches-list__main">
                                    <span class="matches-list__team">Winner QF1</span>
                                    <span class="matches-list__score">?</span>
                                    <span class="matches-list__team">Winner QF2</span>
                                </div>
                                <div class="matches-list__meta">
                                    <span class="status-pill">TBD</span>
                                </div>
                                <button type="button" class="btn btn--sm btn--ghost">Open</button>
                            </div>
                        </li>

                    </ul>
                </div><!-- /.fixture list -->

                <!-- ?? League Table ????????????????????????? -->
                <div class="card large card--tinted">
                    <h3>League table · Football Premier</h3>
                    <p class="hint" style="margin-bottom:14px">
                        Points table for the selected competition.
                    </p>
                    <div class="table-scroll">
                        <table class="data-table data-table--compact league-table">
                            <thead>
                                <tr>
                                    <th>#</th>
                                    <th>Team</th>
                                    <th title="Played">P</th>
                                    <th title="Won">W</th>
                                    <th title="Drawn">D</th>
                                    <th title="Lost">L</th>
                                    <th title="Goals For">GF</th>
                                    <th title="Goals Against">GA</th>
                                    <th title="Goal Difference">GD</th>
                                    <th title="Points">Pts</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr class="league-table__row league-table__row--top">
                                    <td>1</td><td><strong>FSKM</strong></td>
                                    <td>8</td><td>5</td><td>2</td><td>1</td>
                                    <td>16</td><td>9</td><td>+7</td><td><strong>17</strong></td>
                                </tr>
                                <tr class="league-table__row league-table__row--top">
                                    <td>2</td><td><strong>Engineering</strong></td>
                                    <td>8</td><td>4</td><td>1</td><td>3</td>
                                    <td>12</td><td>11</td><td>+1</td><td><strong>13</strong></td>
                                </tr>
                                <tr><td>3</td><td>Science</td>     <td>8</td><td>4</td><td>0</td><td>4</td><td>11</td><td>12</td><td>?1</td><td>12</td></tr>
                                <tr><td>4</td><td>Business</td>    <td>8</td><td>3</td><td>2</td><td>3</td><td>10</td><td>10</td><td>0</td> <td>11</td></tr>
                                <tr><td>5</td><td>Law</td>         <td>8</td><td>3</td><td>1</td><td>4</td><td>9</td> <td>13</td><td>?4</td><td>10</td></tr>
                                <tr><td>6</td><td>Education</td>   <td>8</td><td>2</td><td>3</td><td>3</td><td>8</td> <td>11</td><td>?3</td><td>9</td></tr>
                                <tr><td>7</td><td>FPA</td>         <td>8</td><td>2</td><td>2</td><td>4</td><td>7</td> <td>14</td><td>?7</td><td>8</td></tr>
                                <tr><td>8</td><td>Architecture</td><td>8</td><td>1</td><td>3</td><td>4</td><td>6</td> <td>15</td><td>?9</td><td>6</td></tr>
                            </tbody>
                        </table>
                    </div>
                </div><!-- /.league table -->

            </div><!-- /.dashboard-stack -->
        </section>

    </main>

</body>
</html>
