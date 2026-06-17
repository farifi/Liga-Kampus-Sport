<!DOCTYPE html>
<html lang="en">

<head>
    <%@ include file="/common/head.jsp" %>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/CSS/dashboardCSS.css">

</head>

<body>

<%@ include file="/components/navbar.jsp" %>

<main class="main-content">

<%@ include file="/components/header.jsp" %>

<section id="teams" class="section">

    <h2>Teams &amp; Coaches</h2>

    <div class="dashboard-stack">

        <!-- Add Team & Add Coach - Side by Side -->
        <div class="two-column-layout">

            <!-- Add Team Card -->
            <div class="card card--tinted">
                <h3>Add new team</h3>

                <label for="team-sport">Sport</label>
                <select id="team-sport" style="width: 100%; box-sizing: border-box; margin-bottom: 16px; padding: 8px;">
                    <option value="football" selected>Football</option>
                    <option value="basketball">Basketball</option>
                    <option value="badminton">Badminton</option>
                    <option value="volleyball">Volleyball</option>
                    <option value="tennis">Tennis</option>
                    <option value="futsal">Futsal</option>
                </select>

                <label for="team-competition">Competition</label>
                <select id="team-competition" style="width: 100%; box-sizing: border-box; margin-bottom: 16px; padding: 8px;">
                    <option value="liga-premier" selected>
                        Liga Kampus - Football Premier
                    </option>
                    <option value="futsal-cup">
                        Inter-Faculty Futsal Cup
                    </option>
                    <option value="badminton-open">
                        Badminton Open
                    </option>
                    <option value="basketball-campus">
                        Basketball Campus League
                    </option>
                </select>

                <label for="team-name">Team display name</label>
                <input id="team-name" type="text" placeholder="e.g. FSKM" style="width: 100%; box-sizing: border-box; margin-bottom: 16px; padding: 8px;">

                <label for="team-venue">Venue</label>
                <input id="team-venue" type="text" placeholder="Stadium / court" style="width: 100%; box-sizing: border-box; margin-bottom: 16px; padding: 8px;">

                <button type="button" class="btn btn--primary" style="margin-top: 8px; width: auto;">
                    Save Team
                </button>

                <p class="hint" style="margin-top: 16px;">
                    Register new teams with sport, competition, display name, and home venue.
                </p>
            </div>

            <!-- Add Coach Card -->
            <div class="card card--tinted add-coach-card" style="margin-top:0">
                <h3>Add Coach</h3>

                <label for="coach-name">Full Name</label>
                <input id="coach-name" placeholder="e.g. Assoc. Prof. Rahman" style="width: 100%; box-sizing: border-box; margin-bottom: 12px; padding: 8px;">

                <label for="coach-id">Staff ID</label>
                <input id="coach-id" placeholder="Optional" style="width: 100%; box-sizing: border-box; margin-bottom: 12px; padding: 8px;">

                <label for="coach-email">Email</label>
                <input id="coach-email" type="email" placeholder="coach@example.edu" style="width: 100%; box-sizing: border-box; margin-bottom: 12px; padding: 8px;">

                <label for="coach-phone">Phone</label>
                <input id="coach-phone" type="tel" placeholder="+60 ..." style="width: 100%; box-sizing: border-box; margin-bottom: 12px; padding: 8px;">

                <label for="coach-sport">Sport</label>
                <select id="coach-sport" style="width: 100%; box-sizing: border-box; margin-bottom: 12px; padding: 8px;">
                    <option selected>Football</option>
                    <option>Futsal</option>
                    <option>Basketball</option>
                    <option>Badminton</option>
                    <option>Volleyball</option>
                    <option>Tennis</option>
                </select>

                <button type="button" class="btn btn--primary" style="margin-top:12px; width:auto;">
                    Save Coach
                </button>
            </div>

        </div>

        <!-- Team Overview -->
        <div class="dashboard-columns">

            <!-- Registered Teams -->
            <div class="card card--accent-top card--tinted">

                <h3>Registered teams</h3>

                <ul class="league-list">

                    <li class="league-list__item">

                        <div class="league-list__main">
                            <strong>FSKM</strong>
                            <span class="badge">Football</span>
                        </div>

                        <div class="league-list__meta">
                            Coach: Assoc. Prof. Rahman - 22 players
                        </div>

                        <div class="league-list__foot">

                            <span class="league-list__phase">
                                Liga Kampus - Premier
                            </span>

                            <button type="button" class="btn btn--sm btn--ghost">
                                Open
                            </button>

                        </div>

                    </li>

                    <li class="league-list__item">

                        <div class="league-list__main">
                            <strong>Engineering</strong>
                            <span class="badge">Futsal</span>
                        </div>

                        <div class="league-list__meta">
                            Coach: Ir. Hafiz - 14 players
                        </div>

                        <div class="league-list__foot">

                            <span class="league-list__phase">
                                Inter-Faculty Cup
                            </span>

                            <button type="button" class="btn btn--sm btn--ghost">
                                Open
                            </button>

                        </div>

                    </li>

                    <li class="league-list__item">

                        <div class="league-list__main">
                            <strong>Science</strong>
                            <span class="badge">Basketball</span>
                        </div>

                        <div class="league-list__meta">
                            Coach: Dr. Aminah - 12 players
                        </div>

                        <div class="league-list__foot">

                            <span class="league-list__phase">
                                Campus League
                            </span>

                            <button type="button" class="btn btn--sm btn--ghost">
                                Open
                            </button>

                        </div>

                    </li>

                </ul>

            </div>

            <!-- Featured Coach -->
            <div class="card card--purple card--tinted">

                <h3>Featured coach</h3>

                <p>Assoc. Prof. Rahman</p>

                <p>FSKM</p>

                <p>Football Premier - 22 Players</p>

                <p class="hint" style="margin-top:4px">
                    Manage coach contacts, assistants, and eligibility details here.
                </p>

            </div>

        </div>

        <!-- Teams Directory -->
        <div class="card large card--tinted dashboard-matches-card">

            <h3 class="dashboard-matches-card__title">
                Teams &amp; Coaches Directory
            </h3>

            <p class="hint dashboard-matches-card__intro">
                View all registered teams, assigned coaches, and competition details.
            </p>

            <ul class="dash-matches-list" aria-label="Registered teams">

                <li class="dash-match-card">

                    <div class="fixture-labels">
                        <span>Football</span>
                        <span>22 Players</span>
                    </div>

                    <div class="dash-match-card__body">

                        <div>
                            Liga Kampus - Football Premier
                        </div>

                        <div>
                            FSKM - Coach - Assoc. Prof. Rahman
                        </div>

                        <div>
                            Active
                        </div>

                        <button type="button" class="btn btn--sm btn--ghost">
                            Manage
                        </button>

                    </div>

                </li>

                <li class="dash-match-card">

                    <div class="fixture-labels">
                        <span>Futsal</span>
                        <span>14 Players</span>
                    </div>

                    <div class="dash-match-card__body">

                        <div>
                            Inter-Faculty Futsal Cup
                        </div>

                        <div>
                            Engineering - Coach - Ir. Hafiz
                        </div>

                        <div>
                            Registered
                        </div>

                        <button type="button" class="btn btn--sm btn--ghost">
                            Manage
                        </button>

                    </div>

                </li>

            </ul>

        </div>

        <!-- Team Table -->
        <div class="card large card--tinted">

            <h3>Team registration table</h3>

            <p class="hint" style="margin-bottom:14px">
                Overview of all registered teams, coaches, competitions, and player counts.
            </p>

            <div class="table-scroll">

                <table class="data-table data-table--compact league-table">

                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Team</th>
                            <th>Coach</th>
                            <th>Competition</th>
                            <th>Sport</th>
                            <th>Players</th>
                            <th>Status</th>
                        </tr>
                    </thead>

                    <tbody>

                        <tr>
                            <td>1</td>
                            <td><strong>FSKM</strong></td>
                            <td>Assoc. Prof. Rahman</td>
                            <td>Football Premier</td>
                            <td>Football</td>
                            <td>22</td>
                            <td>Active</td>
                        </tr>

                        <tr>
                            <td>2</td>
                            <td><strong>Engineering</strong></td>
                            <td>Ir. Hafiz</td>
                            <td>Futsal Cup</td>
                            <td>Futsal</td>
                            <td>14</td>
                            <td>Registered</td>
                        </tr>

                        <tr>
                            <td>3</td>
                            <td>Science</td>
                            <td>Dr. Aminah</td>
                            <td>Campus League</td>
                            <td>Basketball</td>
                            <td>12</td>
                            <td>Pending</td>
                        </tr>

                        <tr>
                            <td>4</td>
                            <td>Business</td>
                            <td>Mr. Faiz</td>
                            <td>SUPRO</td>
                            <td>Volleyball</td>
                            <td>10</td>
                            <td>Active</td>
                        </tr>

                    </tbody>

                </table>

            </div>

        </div>

    </div>

</section>

</main>

</body>

</html>