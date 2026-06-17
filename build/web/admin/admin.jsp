<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">

<head>
    <%@ include file="/common/head.jsp" %>

    <!-- Admin Page CSS -->
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/CSS/admin.css">
</head>

<body>

    <%@ include file="/components/navbar.jsp" %>

    <main class="main-content">

        <%@ include file="/components/header.jsp" %>

        <section class="admin-page">

            <div class="page-header">
                <h1>Admin Dashboard</h1>
                <p>
                    Manage competitions, users, sports catalogue,
                    and platform settings.
                </p>
            </div>

            <!-- Statistics -->
            <div class="admin-hero">

                <div class="stat-tile">
                    <div class="stat-value">24</div>
                    <div class="stat-label">Active Teams</div>
                </div>

                <div class="stat-tile">
                    <div class="stat-value">6</div>
                    <div class="stat-label">Sports Configured</div>
                </div>

                <div class="stat-tile">
                    <div class="stat-value">312</div>
                    <div class="stat-label">Registered Players</div>
                </div>

                <div class="stat-tile">
                    <div class="stat-value">18</div>
                    <div class="stat-label">Live & Upcoming Matches</div>
                </div>

            </div>

            <!-- Admin Modules -->
            <div class="admin-grid">

                <div class="admin-tile">

                    <div class="admin-icon navy">
                        👤
                    </div>

                    <h3>Users & Access</h3>

                    <p>
                        Create accounts, reset passwords and
                        assign roles to users.
                    </p>

                    <div class="button-group">
                        <button class="btn btn-primary">
                            Add User
                        </button>

                        <button class="btn btn-ghost">
                            Permissions
                        </button>
                    </div>

                </div>

                <div class="admin-tile">

                    <div class="admin-icon purple">
                        🏆
                    </div>

                    <h3>Competition Management</h3>

                    <p>
                        Manage seasons, fixtures, leagues,
                        knockout brackets and schedules.
                    </p>

                    <div class="button-group">
                        <button class="btn btn-primary">
                            Manage Competition
                        </button>

                        <button class="btn btn-ghost">
                            Schedule
                        </button>
                    </div>

                </div>

                <div class="admin-tile">

                    <div class="admin-icon gold">
                        ⚙
                    </div>

                    <h3>Sports Catalogue</h3>

                    <p>
                        Configure sports, roster limits,
                        scoring systems and competition rules.
                    </p>

                    <div class="button-group">
                        <button class="btn btn-gold">
                            Add Sport
                        </button>
                    </div>

                </div>

            </div>

        </section>

    </main>

</body>
</html>