<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <%@ include file="/common/head.jsp" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/leagueCSS.css">
</head>

<body>

    <%@ include file="/components/navbar.jsp" %>
    
    <main class="main-content">

        <%@ include file="/components/header.jsp" %>

        <section id="analytics" class="section">

            <h2>League standings</h2>
            <p class="hint section-lead">
                Points tables per competition. Switch competition to see different standings.
            </p>

            <div class="standings-stack">

                <!-- Basketball -->
                <div class="card card--tinted">
                    <h3>Basketball · Campus League</h3>
                    <div class="table-scroll">
                        <table class="data-table data-table--compact league-table">
                            <thead>
                                <tr>
                                    <th>#</th>
                                    <th>Team</th>
                                    <th title="Played">P</th>
                                    <th title="Won">W</th>
                                    <th title="Lost">L</th>
                                    <th title="Points For">PF</th>
                                    <th title="Points Against">PA</th>
                                    <th title="Difference">Diff</th>
                                    <th title="Points">Pts</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr class="league-table__row league-table__row--top">
                                    <td>1</td><td><strong>FSKM</strong></td>
                                    <td>6</td><td>5</td><td>1</td>
                                    <td>482</td><td>401</td><td>+81</td><td><strong>10</strong></td>
                                </tr>
                                <tr class="league-table__row league-table__row--top">
                                    <td>2</td><td><strong>Engineering</strong></td>
                                    <td>6</td><td>4</td><td>2</td>
                                    <td>455</td><td>420</td><td>+35</td><td><strong>8</strong></td>
                                </tr>
                                <tr>
                                    <td>3</td><td>Business</td>
                                    <td>6</td><td>3</td><td>3</td>
                                    <td>430</td><td>430</td><td>0</td><td>6</td>
                                </tr>
                                <tr>
                                    <td>4</td><td>Science</td>
                                    <td>6</td><td>2</td><td>4</td>
                                    <td>410</td><td>448</td><td>−38</td><td>4</td>
                                </tr>
                                <tr>
                                    <td>5</td><td>Law</td>
                                    <td>6</td><td>1</td><td>5</td>
                                    <td>388</td><td>466</td><td>−78</td><td>2</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- Futsal -->
                <div class="card card--tinted">
                    <h3>Futsal · Inter-Faculty Cup · Group A</h3>
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
                                    <th title="Points">Pts</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr class="league-table__row league-table__row--top">
                                    <td>1</td><td><strong>FSKM</strong></td>
                                    <td>3</td><td>2</td><td>1</td><td>0</td>
                                    <td>9</td><td>5</td><td><strong>7</strong></td>
                                </tr>
                                <tr>
                                    <td>2</td><td>Law</td>
                                    <td>3</td><td>1</td><td>1</td><td>1</td>
                                    <td>8</td><td>8</td><td>4</td>
                                </tr>
                                <tr>
                                    <td>3</td><td>Architecture</td>
                                    <td>3</td><td>1</td><td>0</td><td>2</td>
                                    <td>7</td><td>9</td><td>3</td>
                                </tr>
                                <tr>
                                    <td>4</td><td>Medicine</td>
                                    <td>3</td><td>1</td><td>0</td><td>2</td>
                                    <td>6</td><td>8</td><td>3</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>

            </div><!-- /.standings-stack -->

        </section>

    </main>

</body>
</html>
