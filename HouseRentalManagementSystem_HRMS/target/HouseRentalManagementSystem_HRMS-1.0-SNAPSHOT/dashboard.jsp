<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:if test="${empty sessionScope.userRole}">
    <c:redirect url="login.jsp"/>
</c:if>

<!DOCTYPE html>
<html lang="en">
<head>
    <title>Rent4Student | Dashboard</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        @keyframes blob { 0% { transform: translate(0px, 0px) scale(1); } 33% { transform: translate(30px, -50px) scale(1.1); } 66% { transform: translate(-20px, 20px) scale(0.9); } 100% { transform: translate(0px, 0px) scale(1); } }
        .animate-blob { animation: blob 7s infinite; }
        .animation-delay-2000 { animation-delay: 2s; }
    </style>
</head>
<body class="bg-slate-50 font-sans text-slate-800 min-h-screen relative overflow-x-hidden">

    <div class="absolute top-0 left-20 w-96 h-96 bg-orange-300 rounded-full mix-blend-multiply filter blur-[120px] opacity-20 animate-blob pointer-events-none z-0"></div>
    <div class="absolute top-40 right-20 w-96 h-96 bg-blue-300 rounded-full mix-blend-multiply filter blur-[120px] opacity-20 animate-blob animation-delay-2000 pointer-events-none z-0"></div>

    <nav class="bg-white/80 backdrop-blur-md border-b border-slate-200 sticky top-0 z-50 shadow-sm">
        <div class="max-w-7xl mx-auto px-6 py-3 flex justify-between items-center">
            
            <div class="flex items-center gap-2">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-8 w-8 text-orange-500" viewBox="0 0 24 24" fill="currentColor"><path d="M12 3L1 9l4 2.18v6L12 21l7-3.82v-6l2-1.09V17h2V9L12 3zm6.82 6L12 12.72 5.18 9 12 5.28 18.82 9zM17 15.99l-5 2.73-5-2.73v-3.72l5 2.73 5-2.73v3.72z"/></svg>
                <h1 class="text-2xl font-black text-slate-900 tracking-tight">Rent<span class="text-orange-500">4</span>Student</h1>
            </div>

            <div class="hidden md:flex gap-6 text-sm font-bold text-slate-600">
                <a href="dashboard.jsp" class="text-orange-500 border-b-2 border-orange-500 pb-1">Dashboard</a>
                <a href="properties" class="hover:text-orange-500 transition-colors pb-1">Properties</a>
                <a href="applicationController" class="hover:text-orange-500 transition-colors pb-1">Applications</a>
                <a href="rentalController" class="hover:text-orange-500 transition-colors pb-1">Rentals</a>
                
                <c:choose>
                    <c:when test="${sessionScope.userRole == 'student'}"><a href="paymentController" class="hover:text-orange-500 transition-colors pb-1">Payments</a></c:when>
                    <c:when test="${sessionScope.userRole == 'owner'}"><a href="receipts.jsp" class="hover:text-orange-500 transition-colors pb-1">Receipts</a></c:when>
                </c:choose>
            </div>

            <div class="flex items-center gap-4">
                <div class="text-right hidden sm:block">
                    <p class="text-sm font-bold text-slate-800 leading-tight">
                        <c:choose>
                            <c:when test="${sessionScope.userRole == 'admin'}">${sessionScope.adminName}</c:when>
                            <c:otherwise>${sessionScope.loggedUser.fullName}</c:otherwise>
                        </c:choose>
                    </p>
                    <p class="text-xs text-slate-500 capitalize">${sessionScope.userRole}</p>
                </div>
                <form action="auth" method="POST" class="m-0">
                    <input type="hidden" name="action" value="logout">
                    <button type="submit" class="bg-white hover:bg-red-50 text-red-600 border border-slate-200 font-bold py-2 px-4 rounded-xl transition-all text-sm shadow-sm">Logout</button>
                </form>
            </div>
        </div>
    </nav>

    <main class="max-w-7xl mx-auto px-6 py-12 relative z-10">
        <div class="bg-white rounded-3xl p-10 shadow-xl shadow-slate-200/40 border border-slate-100 mb-8 flex flex-col md:flex-row items-center justify-between gap-6 transform hover:-translate-y-1 transition-all duration-300">
            <div>
                <h2 class="text-4xl font-extrabold text-slate-900 mb-2">Welcome to your Dashboard.</h2>
                <p class="text-slate-500 text-lg">
                    <c:choose>
                        <c:when test="${sessionScope.userRole == 'student'}">Browse available properties, track your applications, and manage your rent all in one secure place.</c:when>
                        <c:when test="${sessionScope.userRole == 'owner'}">Manage your property listings, review student applications, and track your incoming rent seamlessly.</c:when>
                        <c:otherwise>System administration portal. Use the navigation to oversee operations.</c:otherwise>
                    </c:choose>
                </p>
            </div>
            <div class="shrink-0">
                <c:choose>
                    <c:when test="${sessionScope.userRole == 'student'}">
                        <a href="properties" class="inline-block bg-gradient-to-r from-orange-500 to-orange-600 hover:from-orange-400 hover:to-orange-500 text-white font-bold py-3 px-8 rounded-xl shadow-lg transition-all">Find a Property</a>
                    </c:when>
                    <c:when test="${sessionScope.userRole == 'owner'}">
                        <a href="properties" class="inline-block bg-gradient-to-r from-blue-600 to-blue-700 hover:from-blue-500 hover:to-blue-600 text-white font-bold py-3 px-8 rounded-xl shadow-lg transition-all">Manage Properties</a>
                    </c:when>
                </c:choose>
            </div>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
            <a href="properties" class="bg-white p-6 rounded-2xl shadow-sm border border-slate-100 flex items-center gap-4 hover:shadow-md hover:border-blue-200 transition-all group">
                <div class="w-14 h-14 bg-blue-50 text-blue-500 rounded-xl flex items-center justify-center text-2xl group-hover:scale-110 transition-transform"><svg class="w-7 h-7" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"></path></svg></div>
                <div><p class="text-sm font-bold text-slate-400 uppercase tracking-wider">Properties</p><p class="text-2xl font-black text-slate-800 group-hover:text-blue-600 transition-colors">View Hub</p></div>
            </a>
            
            <a href="applicationController" class="bg-white p-6 rounded-2xl shadow-sm border border-slate-100 flex items-center gap-4 hover:shadow-md hover:border-orange-200 transition-all group">
                <div class="w-14 h-14 bg-orange-50 text-orange-500 rounded-xl flex items-center justify-center text-2xl group-hover:scale-110 transition-transform"><svg class="w-7 h-7" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"></path></svg></div>
                <div><p class="text-sm font-bold text-slate-400 uppercase tracking-wider">Applications</p><p class="text-2xl font-black text-slate-800 group-hover:text-orange-600 transition-colors">Track Status</p></div>
            </a>
            
            <a href="${sessionScope.userRole == 'student' ? 'paymentController' : 'receipts.jsp'}" class="bg-white p-6 rounded-2xl shadow-sm border border-slate-100 flex items-center gap-4 hover:shadow-md hover:border-green-200 transition-all group">
                <div class="w-14 h-14 bg-green-50 text-green-500 rounded-xl flex items-center justify-center text-2xl group-hover:scale-110 transition-transform"><svg class="w-7 h-7" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg></div>
                <div><p class="text-sm font-bold text-slate-400 uppercase tracking-wider">Financials</p><p class="text-2xl font-black text-slate-800 group-hover:text-green-600 transition-colors">Manage Rent</p></div>
            </a>
        </div>
    </main>
</body>
</html>