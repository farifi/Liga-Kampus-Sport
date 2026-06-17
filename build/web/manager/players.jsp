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

<section id="players" class="section">
    <h2>Player management</h2>

    <p class="hint" style="margin-bottom:16px">Browse by sport -> team -> players. Racket sports add
        <strong>Singles</strong> / <strong>Doubles</strong>. Use CRUD for sports, teams, and roster rows.</p>

    <div class="crud-toolbar">
        <button type="button" class="btn btn--primary">Add sport</button>
        <button type="button" class="btn btn--secondary">Edit sport</button>
        <button type="button" class="btn btn--danger">Remove sport</button>
        <button type="button" class="btn btn--gold">Add team</button>
        <button type="button" class="btn btn--ghost">Edit team</button>
        <button type="button" class="btn btn--ghost">Delete team</button>
    </div>

    <div class="filter-tabs" role="tablist" aria-label="Sport categories">
        <button type="button" class="is-active">Football</button>
        <button type="button">Basketball</button>
        <button type="button">Volleyball</button>
        <button type="button">Futsal</button>
        <button type="button">Badminton</button>
        <button type="button">Tennis</button>
    </div>

    <!-- Football example -->
    <div class="sport-block">
        <div class="sport-block__head">
            <h3>Football</h3>
            <div class="sport-block__actions">
                <button type="button" class="btn btn--ghost"
                    style="color:#fff;border-color:rgba(255,255,255,0.35)">Sport settings</button>
            </div>
        </div>

        <div class="team-row">
            <div class="team-row__title">
                <strong>FSKM</strong>
                <div>
                    <span class="badge">Faculty team</span>
                    <button type="button" class="btn btn--sm btn--ghost">Edit team</button>
                    <button type="button" class="btn btn--sm btn--primary">Add player</button>
                </div>
            </div>

            <div class="team-stats" aria-label="FSKM team statistics">
                <div class="team-stats__title">Team statistics � Football � Liga Premier</div>
                <div class="team-stats__grid">
                    <div class="team-stats__item"><span class="team-stats__label">P</span><span
                            class="team-stats__value">8</span></div>
                    <div class="team-stats__item"><span class="team-stats__label">W-D-L</span><span
                            class="team-stats__value">5-2-1</span></div>
                    <div class="team-stats__item"><span class="team-stats__label">GF / GA</span><span
                            class="team-stats__value">16 / 9</span></div>
                    <div class="team-stats__item"><span class="team-stats__label">GD</span><span
                            class="team-stats__value">+7</span></div>
                    <div class="team-stats__item"><span class="team-stats__label">Pts</span><span
                            class="team-stats__value team-stats__value--accent">17</span></div>
                    <div class="team-stats__item"><span class="team-stats__label">Team fouls</span><span
                            class="team-stats__value">62</span></div>
                    <div class="team-stats__item"><span class="team-stats__label">YC / RC</span><span
                            class="team-stats__value">9 / 0</span></div>
                    <div class="team-stats__item"><span class="team-stats__label">Clean sheets</span><span
                            class="team-stats__value">3</span></div>
                </div>
            </div>

            <table class="player-table">
                <thead>
                    <tr>
                        <th>Name</th>
                        <th>Student ID</th>
                        <th>#</th>
                        <th>Position</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>Ahmad Zaki</td>
                        <td>2023123456</td>
                        <td>10</td>
                        <td>Forward</td>
                        <td><span class="inline-actions"><button type="button"
                                    class="btn btn--sm btn--ghost">Edit</button><button type="button"
                                    class="btn btn--sm btn--danger">Delete</button></span></td>
                    </tr>
                    <tr>
                        <td>Daniel Haqimi</td>
                        <td>2023987654</td>
                        <td>7</td>
                        <td>Midfielder</td>
                        <td><span class="inline-actions"><button type="button"
                                    class="btn btn--sm btn--ghost">Edit</button><button type="button"
                                    class="btn btn--sm btn--danger">Delete</button></span></td>
                    </tr>
                </tbody>
            </table>
        </div>

        <div class="team-row">
            <div class="team-row__title">
                <strong>Engineering</strong>
                <div>
                    <span class="badge">Faculty team</span>
                    <button type="button" class="btn btn--sm btn--ghost">Edit team</button>
                    <button type="button" class="btn btn--sm btn--primary">Add player</button>
                </div>
            </div>

            <div class="team-stats" aria-label="Engineering team statistics">
                <div class="team-stats__title">Team statistics � Football � Liga Premier</div>
                <div class="team-stats__grid">
                    <div class="team-stats__item"><span class="team-stats__label">P</span><span
                            class="team-stats__value">8</span></div>
                    <div class="team-stats__item"><span class="team-stats__label">W-D-L</span><span
                            class="team-stats__value">4-1-3</span></div>
                    <div class="team-stats__item"><span class="team-stats__label">GF / GA</span><span
                            class="team-stats__value">12 / 11</span></div>
                    <div class="team-stats__item"><span class="team-stats__label">GD</span><span
                            class="team-stats__value">+1</span></div>
                    <div class="team-stats__item"><span class="team-stats__label">Pts</span><span
                            class="team-stats__value team-stats__value--accent">13</span></div>
                    <div class="team-stats__item"><span class="team-stats__label">Team fouls</span><span
                            class="team-stats__value">55</span></div>
                    <div class="team-stats__item"><span class="team-stats__label">YC / RC</span><span
                            class="team-stats__value">6 / 1</span></div>
                    <div class="team-stats__item"><span class="team-stats__label">Clean sheets</span><span
                            class="team-stats__value">2</span></div>
                </div>
            </div>

            <table class="player-table">
                <thead>
                    <tr>
                        <th>Name</th>
                        <th>Student ID</th>
                        <th>#</th>
                        <th>Position</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>Faris Iqbal</td>
                        <td>2023778899</td>
                        <td>9</td>
                        <td>Forward</td>
                        <td><span class="inline-actions"><button type="button"
                                    class="btn btn--sm btn--ghost">Edit</button><button type="button"
                                    class="btn btn--sm btn--danger">Delete</button></span></td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Badminton: solo vs doubles -->
    <div class="sport-block">
        <div class="sport-block__head">
            <h3>Badminton</h3>
            <div class="sport-block__actions">
                <button type="button" class="btn btn--ghost"
                    style="color:#fff;border-color:rgba(255,255,255,0.35)">Sport settings</button>
            </div>
        </div>

        <div class="team-row">
            <div class="team-row__title">
                <strong>FSKM</strong>
                <div>
                    <span class="badge badge--gold">Racket</span>
                    <button type="button" class="btn btn--sm btn--ghost">Edit team</button>
                    <button type="button" class="btn btn--sm btn--primary">Add player</button>
                </div>
            </div>

            <div class="team-stats team-stats--racket" aria-label="FSKM badminton team statistics">
                <div class="team-stats__title">Team statistics � Badminton � Open</div>
                <div class="team-stats__grid">
                    <div class="team-stats__item"><span class="team-stats__label">Matches</span><span
                            class="team-stats__value">10</span></div>
                    <div class="team-stats__item"><span class="team-stats__label">Match W-L</span><span
                            class="team-stats__value">7-3</span></div>
                    <div class="team-stats__item"><span class="team-stats__label">Rubbers W-L</span><span
                            class="team-stats__value">18-12</span></div>
                    <div class="team-stats__item"><span class="team-stats__label">Pts for / against</span><span
                            class="team-stats__value">412 / 388</span></div>
                    <div class="team-stats__item"><span class="team-stats__label">Table rank</span><span
                            class="team-stats__value team-stats__value--accent">3rd</span></div>
                </div>
            </div>

            <div class="racket-split">
                <div class="racket-col">
                    <h4>Singles</h4>
                    <table class="player-table">
                        <thead>
                            <tr>
                                <th>Name</th>
                                <th>Student ID</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>Nur Aina</td>
                                <td>2023665544</td>
                                <td><span class="inline-actions"><button type="button"
                                            class="btn btn--sm btn--ghost">Edit</button><button type="button"
                                            class="btn btn--sm btn--danger">Delete</button></span></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <div class="racket-col">
                    <h4>Doubles</h4>
                    <table class="player-table">
                        <thead>
                            <tr>
                                <th>Name</th>
                                <th>Student ID</th>
                                <th>Pair</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>Hafiz and Raihan</td>
                                <td>2023... / 2023...</td>
                                <td>Pair A</td>
                                <td><span class="inline-actions"><button type="button"
                                            class="btn btn--sm btn--ghost">Edit</button><button type="button"
                                            class="btn btn--sm btn--danger">Delete</button></span></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <div class="team-row">
            <div class="team-row__title">
                <strong>Engineering</strong>
                <div>
                    <span class="badge badge--gold">Racket</span>
                    <button type="button" class="btn btn--sm btn--ghost">Edit team</button>
                    <button type="button" class="btn btn--sm btn--primary">Add player</button>
                </div>
            </div>

            <div class="team-stats team-stats--racket" aria-label="Engineering badminton team statistics">
                <div class="team-stats__title">Team statistics � Badminton � Open</div>
                <div class="team-stats__grid">
                    <div class="team-stats__item"><span class="team-stats__label">Matches</span><span
                            class="team-stats__value">8</span></div>
                    <div class="team-stats__item"><span class="team-stats__label">Match W-L</span><span
                            class="team-stats__value">4-4</span></div>
                    <div class="team-stats__item"><span class="team-stats__label">Rubbers W-L</span><span
                            class="team-stats__value">14-14</span></div>
                    <div class="team-stats__item"><span class="team-stats__label">Pts for / against</span><span
                            class="team-stats__value">380 / 381</span></div>
                    <div class="team-stats__item"><span class="team-stats__label">Table rank</span><span
                            class="team-stats__value team-stats__value--accent">6th</span></div>
                </div>
            </div>

            <div class="racket-split">
                <div class="racket-col">
                    <h4>Singles</h4>
                    <p class="hint">No players yet - add via <strong>Add player</strong>.</p>
                </div>
                <div class="racket-col">
                    <h4>Doubles</h4>
                    <p class="hint">Register pairs for league doubles brackets.</p>
                </div>
            </div>
        </div>
    </div>

    <div class="split-panels">
        <div class="card">
            <h3>Add / edit player (form)</h3>
            <label for="p-name">Full name</label>
            <input id="p-name" placeholder="Full name" style="width: 100%; box-sizing: border-box; margin-bottom: 12px; padding: 8px;">
            
            <label for="p-id">Student ID</label>
            <input id="p-id" placeholder="Student ID" style="width: 100%; box-sizing: border-box; margin-bottom: 12px; padding: 8px;">
            
            <label for="p-num">Jersey / seed number (if applicable)</label>
            <input id="p-num" placeholder="Number" style="width: 100%; box-sizing: border-box; margin-bottom: 12px; padding: 8px;">
            
            <label for="p-pos">Position or role</label>
            <select id="p-pos" style="width: 100%; box-sizing: border-box; margin-bottom: 12px; padding: 8px;">
                <option>Forward</option>
                <option>Midfielder</option>
                <option>Defender</option>
                <option>Goalkeeper</option>
                <option>Singles</option>
                <option>Doubles</option>
            </select>
            
            <label for="p-team">Team</label>
            <select id="p-team" style="width: 100%; box-sizing: border-box; margin-bottom: 12px; padding: 8px;">
                <option>FSKM</option>
                <option>Engineering</option>
            </select>
            
            <label for="p-sport">Sport</label>
            <select id="p-sport" style="width: 100%; box-sizing: border-box; margin-bottom: 12px; padding: 8px;">
                <option>Football</option>
                <option>Badminton</option>
            </select>
            
            <button type="button" class="btn btn--primary" style="margin-top:12px;width:auto">Save player</button>
        </div>
        
        <div class="card">
            <h3>Player performance (detail)</h3>
            <p>Linked from roster row - example:</p>
            <p><strong>Goals:</strong> 8</p>
            <p><strong>Assists:</strong> 5</p>
            <p><strong>Yellow cards:</strong> 1</p>
            <p><strong>Red cards:</strong> 0</p>
            <p><strong>Rating:</strong> 8.9</p>
            <p class="hint" style="margin-top:12px">In production, open as drawer or separate page from
                <strong>Edit</strong>.</p>
        </div>
    </div>
</section>

</main>

</body>

</html>