<%@ page import="Model.User" pageEncoding="UTF-8" language="java"%>

<!DOCTYPE html>
<html lang="en">

<head>
    <%@ include file="/common/head.jsp" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/competitionCSS.css">
</head>

<body>

    <%@ include file="/components/navbar.jsp" %>

    <main class="main-content">

        <%@ include file="/components/header.jsp" %>

        <section id="competitions" class="section management-container">
            <div class="management-card">

                <header class="management-header">
                    <h2>Competition management</h2>
                </header>

                <div class="table-responsive">
                    <table class="management-table">
                        <thead>
                            <tr>
                                <th>Match ID</th>
                                <th>Fixture</th>
                                <th>Score</th>
                                <th>Venue &amp; Date</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>

                            <!-- Match Row 1 (Completed) -->
                            <tr>
                                <td class="font-bold">QF · Match 1</td>
                                <td>FSKM vs Business</td>
                                <td class="font-bold">1 - 0</td>
                                <td>Stadium A <br><small>14 May 20:30</small></td>
                                <td class="action-buttons">
                                    <button type="button" class="btn-edit">Edit</button>
                                    <button type="button" class="btn-withdraw">Void</button>
                                </td>
                            </tr>

                            <!-- Match Row 2 (Pending) -->
                            <tr>
                                <td class="font-bold">QF · Match 2</td>
                                <td>Science vs Winner R16 M4</td>
                                <td class="text-muted">—</td>
                                <td>Stadium B <br><small>16 May 18:00</small></td>
                                <td class="action-buttons">
                                    <button type="button" class="btn-edit">Set Score</button>
                                    <button type="button" class="btn-withdraw">Remove</button>
                                </td>
                            </tr>

                        </tbody>
                    </table>
                </div>

            </div>
        </section>

    </main>

</body>
</html>
