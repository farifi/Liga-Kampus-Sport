<%@ page contentType="text/html;charset=UTF-8" %>

<!-- Page Header Component -->
<header class="page-header">
    <div class="page-header__left">
        <span class="page-header__title">LIGA-KAMPUS</span>
        <span class="page-header__subtitle">Welcome back — here's what's happening today</span>
    </div>
    <div class="page-header__right">
        <div class="user-pill">
            <div class="user-pill__avatar">AD</div>
            <div>
                <div class="user-pill__name">Admin</div>
                <div class="user-pill__role">Administrator</div>
            </div>
        </div>
        <button type="button" class="btn--logout"
            onclick="window.location.href='${pageContext.request.contextPath}/login.jsp'">
            Logout
        </button>
    </div>
</header>
