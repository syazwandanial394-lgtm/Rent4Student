<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:if test="${sessionScope.userRole != 'admin'}">
    <c:redirect url="login.jsp"/>
</c:if>

<!DOCTYPE html>
<html lang="en">
<head>
    <title>HRMS - System Administration</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-900 text-gray-200 min-h-screen">
    
    <!-- Admin Navigation -->
    <nav class="bg-black p-4 flex justify-between items-center shadow-lg border-b border-gray-800">
        <div class="flex gap-6 items-center text-white">
            <h1 class="font-black text-xl text-red-500 tracking-widest">RENTEASE ROOT</h1>
            <span class="bg-red-600 text-white text-xs font-bold px-2 py-1 rounded">MAINTENANCE MODE</span>
        </div>
        <div class="flex items-center gap-4">
            <span class="font-semibold text-sm text-gray-400">Authorized: ${sessionScope.adminName}</span>
            <form action="auth" method="POST" class="m-0">
                <input type="hidden" name="action" value="logout">
                <button type="submit" class="border border-red-500 text-red-500 hover:bg-red-500 hover:text-white px-3 py-1 rounded text-sm font-bold transition">Terminate Session</button>
            </form>
        </div>
    </nav>

    <!-- Main Content -->
    <main class="p-8 max-w-6xl mx-auto mt-6">
        <h2 class="text-3xl font-extrabold text-white mb-6">System Overview</h2>
        
        <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
            <div class="bg-gray-800 p-6 rounded-lg border border-gray-700 shadow-md">
                <h3 class="text-gray-400 font-bold mb-2 uppercase text-sm">Server Status</h3>
                <div class="text-2xl font-black text-green-400">ONLINE</div>
                <p class="text-xs text-gray-500 mt-2">GlassFish 7.0 / Jakarta EE 10</p>
            </div>
            <div class="bg-gray-800 p-6 rounded-lg border border-gray-700 shadow-md">
                <h3 class="text-gray-400 font-bold mb-2 uppercase text-sm">Database Connection</h3>
                <div class="text-2xl font-black text-green-400">ACTIVE</div>
                <p class="text-xs text-gray-500 mt-2">MySQL: hrms_db</p>
            </div>
            <div class="bg-gray-800 p-6 rounded-lg border border-gray-700 shadow-md">
                <h3 class="text-gray-400 font-bold mb-2 uppercase text-sm">Active Sessions</h3>
                <div class="text-2xl font-black text-blue-400">1</div>
                <p class="text-xs text-gray-500 mt-2">Current Admin Session</p>
            </div>
        </div>

        <div class="bg-gray-800 p-8 rounded-lg border border-gray-700 shadow-md text-center">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-16 w-16 text-yellow-500 mx-auto mb-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
            </svg>
            <h3 class="text-xl font-bold text-white mb-2">Developer Operations</h3>
            <p class="text-gray-400 max-w-xl mx-auto">
                Advanced database CRUD operations and system metric tracking will be deployed here in future updates. Ensure all testing is complete before shifting to production.
            </p>
        </div>
    </main>

</body>
</html>