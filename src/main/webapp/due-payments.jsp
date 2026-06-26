<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:if test="${empty sessionScope.userRole || sessionScope.userRole != 'owner'}">
    <c:redirect url="login.jsp"/>
</c:if>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Rent4Student | Due Payments</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        @keyframes blob { 0% { transform: translate(0px, 0px) scale(1); } 33% { transform: translate(30px, -50px) scale(1.1); } 66% { transform: translate(-20px, 20px) scale(0.9); } 100% { transform: translate(0px, 0px) scale(1); } }
        .animate-blob { animation: blob 7s infinite; }
        .modal-enter { opacity: 0; transform: scale(0.95); transition: all 0.3s ease-out; }
        .modal-enter-active { opacity: 1; transform: scale(1); }
        .loader { border: 4px solid #f3f4f6; border-top: 4px solid #f97316; border-radius: 50%; width: 40px; height: 40px; animation: spin 1s linear infinite; margin: 0 auto; }
        @keyframes spin { 0% { transform: rotate(0deg); } 100% { transform: rotate(360deg); } }
    </style>
</head>
<body class="bg-slate-50 font-sans text-slate-800 min-h-screen relative overflow-x-hidden overflow-y-scroll">
    <div class="absolute top-0 left-20 w-96 h-96 bg-orange-300 rounded-full mix-blend-multiply filter blur-[120px] opacity-20 animate-blob pointer-events-none z-0"></div>

    <nav class="bg-white/80 backdrop-blur-md border-b border-slate-200 sticky top-0 z-50 shadow-sm relative z-[60]">
        <div class="max-w-7xl mx-auto px-6 py-3 flex justify-between items-center">
            <div class="flex items-center gap-2">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-8 w-8 text-orange-500" viewBox="0 0 24 24" fill="currentColor"><path d="M12 3L1 9l4 2.18v6L12 21l7-3.82v-6l2-1.09V17h2V9L12 3zm6.82 6L12 12.72 5.18 9 12 5.28 18.82 9zM17 15.99l-5 2.73-5-2.73v-3.72l5 2.73 5-2.73v3.72z"/></svg>
                <h1 class="text-2xl font-black text-slate-900 tracking-tight">Rent<span class="text-orange-500">4</span>Student</h1>
            </div>
            <div class="hidden md:flex gap-6 text-sm font-bold text-slate-600">
                <a href="dashboard" class="border-b-2 border-transparent hover:text-orange-500 transition-colors pb-1">Dashboard</a>
                <a href="properties" class="border-b-2 border-transparent hover:text-orange-500 transition-colors pb-1">Properties</a>
                <a href="applicationController" class="border-b-2 border-transparent hover:text-orange-500 transition-colors pb-1">Applications</a>
                <a href="rentalController" class="border-b-2 border-transparent hover:text-orange-500 transition-colors pb-1">Rentals</a>
                <a href="paymentController" class="border-b-2 border-transparent hover:text-orange-500 transition-colors pb-1">Revenue</a>
            </div>
            <div class="flex items-center gap-2">
                <div class="hidden md:block text-right mr-2">
                    <p class="text-xs text-slate-400 font-bold uppercase tracking-wider mb-0.5">Welcome,</p>
                    <p class="text-sm font-black text-slate-800 leading-none">${sessionScope.loggedUser.username}</p>
                </div>
                <button onclick="toggleProfileDrawer()" class="w-10 h-10 rounded-full bg-gradient-to-tr from-orange-400 to-orange-500 text-white font-black flex items-center justify-center shadow-md hover:shadow-lg hover:scale-105 transition-all outline-none focus:ring-4 focus:ring-orange-200 shrink-0 overflow-hidden border-2 border-white">
                    <c:choose>
                        <c:when test="${not empty sessionScope.loggedUser.profileImage}"><img src="${sessionScope.loggedUser.profileImage}" class="w-full h-full object-cover" alt="Profile"></c:when>
                        <c:otherwise>${sessionScope.loggedUser.fullName.substring(0,1).toUpperCase()}</c:otherwise>
                    </c:choose>
                </button>
            </div>
        </div>
    </nav>

    <main class="max-w-4xl mx-auto px-6 py-12 relative z-10">
        
        <div class="mb-8">
            <h2 class="text-3xl font-extrabold text-slate-900">Rented Properties with Due Payments</h2>
            <p class="text-slate-500 mt-1">Select a specific property to view due details and send reminders.</p>
        </div>

        <div class="bg-white rounded-3xl shadow-sm border border-slate-100 overflow-hidden">
            <table class="w-full text-left border-collapse">
                <thead>
                    <tr class="bg-slate-50 text-slate-500 text-xs uppercase tracking-wider border-b border-slate-100">
                        <th class="p-6 font-bold">Property Name</th>
                        <th class="p-6 font-bold">Tenant</th>
                        <th class="p-6 font-bold text-center">Status</th>
                        <th class="p-6 font-bold text-right">Action</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-slate-100">
                    <c:forEach items="${dueRentals}" var="rental">
                        <tr class="hover:bg-slate-50 transition-colors">
                            <td class="p-6 font-bold text-slate-800">${rental.propertyName}</td>
                            <td class="p-6 text-slate-600">${rental.studentName}</td>
                            <td class="p-6 text-center"><span class="bg-red-100 text-red-700 font-bold text-xs px-3 py-1 rounded-full uppercase tracking-wide">Payment Due</span></td>
                            <td class="p-6 text-right">
                                <button type="button" onclick="openDetailsModal('${rental.rentalId}', '${rental.propertyName}', '${rental.studentName}', '${rental.rentalRate}')" class="bg-slate-900 hover:bg-slate-800 text-white font-bold py-2 px-6 rounded-lg text-sm transition-colors shadow-sm">Select Property</button>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty dueRentals}">
                        <tr><td colspan="4" class="p-10 text-center text-slate-500 font-bold">No properties currently have due payments.</td></tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </main>

    <div id="detailsModal" class="fixed inset-0 z-[100] hidden flex items-center justify-center p-4">
        <div class="absolute inset-0 bg-slate-900/60 backdrop-blur-sm" onclick="closeDetailsModal()"></div>
        <div class="relative bg-white rounded-3xl border border-slate-200 shadow-2xl p-8 w-full max-w-md modal-enter" id="detailsContent">
            <div class="flex justify-between items-center border-b border-slate-100 pb-4 mb-6">
                <h2 class="text-2xl font-black text-slate-900 flex items-center gap-2"><svg class="w-6 h-6 text-red-500" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg> Due Details</h2>
                <button onclick="closeDetailsModal()" class="text-slate-400 hover:text-slate-700 transition-colors"><svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path></svg></button>
            </div>
            
            <div class="bg-red-50 border border-red-100 rounded-xl p-5 mb-6">
                <div class="mb-4">
                    <p class="text-xs font-bold text-red-400 uppercase">Property</p>
                    <p class="font-bold text-slate-900" id="detPropName">--</p>
                </div>
                <div class="mb-4">
                    <p class="text-xs font-bold text-red-400 uppercase">Tenant Name</p>
                    <p class="font-bold text-slate-900" id="detTenant">--</p>
                </div>
                <div class="border-t border-red-200 pt-4 flex justify-between items-center">
                    <p class="text-sm font-bold text-red-500 uppercase">Total Amount Due</p>
                    <p class="text-2xl font-black text-red-600" id="detAmount">--</p>
                </div>
            </div>

            <form id="reminderForm" action="rentalController" method="POST" class="m-0">
                <input type="hidden" name="action" value="sendReminder">
                <input type="hidden" name="rentalId" id="detRentalId" value="">
                <button type="button" onclick="triggerReminder()" class="w-full bg-red-600 hover:bg-red-700 text-white font-bold py-3 rounded-xl shadow-lg transition-all flex items-center justify-center gap-2">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9"></path></svg> 
                    Send Official Reminder
                </button>
            </form>
        </div>
    </div>

    <div id="reminderLoadModal" class="fixed inset-0 z-[110] hidden flex items-center justify-center">
        <div class="absolute inset-0 bg-slate-900/80 backdrop-blur-md"></div>
        <div class="relative bg-white rounded-3xl border border-slate-200 shadow-2xl p-10 w-full max-w-sm text-center modal-enter" id="reminderLoadContent">
            <div class="loader mb-6"></div>
            <h2 class="text-2xl font-black text-slate-900 tracking-tight mb-2">Sending Notice</h2>
            <p class="text-slate-500 text-sm">Dispatching official payment reminder<br>to the tenant's profile...</p>
        </div>
    </div>

    <div id="profileBackdrop" onclick="toggleProfileDrawer()" class="fixed inset-0 bg-slate-900/40 backdrop-blur-sm z-[100] hidden opacity-0 transition-opacity duration-300"></div>
    <div id="profileDrawer" class="fixed top-0 right-0 h-full w-80 bg-white shadow-2xl z-[101] transform translate-x-full transition-transform duration-300 ease-in-out flex flex-col border-l border-slate-100">
        <div class="p-6 bg-slate-50 border-b border-slate-100 flex justify-between items-start">
            <button onclick="toggleProfileDrawer()" class="text-slate-400 hover:text-red-500 transition-colors bg-white rounded-full p-1 shadow-sm"><svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path></svg></button>
        </div>
        <div class="p-4 flex-1 flex flex-col gap-2 overflow-y-auto">
            <a href="dashboard" class="flex items-center gap-3 p-3 rounded-xl hover:bg-slate-100 text-slate-700 hover:text-slate-900 font-bold transition-all group">Dashboard Home</a>
            </div>
    </div>

    <script>
        function openDetailsModal(rentalId, propName, tenant, amount) {
            document.getElementById('detRentalId').value = rentalId;
            document.getElementById('detPropName').innerText = propName;
            document.getElementById('detTenant').innerText = tenant;
            document.getElementById('detAmount').innerText = "RM " + amount;
            
            document.getElementById('detailsModal').classList.remove('hidden');
            setTimeout(() => { document.getElementById('detailsContent').classList.add('modal-enter-active'); }, 10);
        }

        function closeDetailsModal() {
            document.getElementById('detailsContent').classList.remove('modal-enter-active');
            setTimeout(() => { document.getElementById('detailsModal').classList.add('hidden'); }, 300);
        }

        function triggerReminder() {
            closeDetailsModal();
            document.getElementById('reminderLoadModal').classList.remove('hidden');
            setTimeout(() => { document.getElementById('reminderLoadContent').classList.add('modal-enter-active'); }, 10);
            
            // Wait 1.5 seconds for effect, then submit to controller to route to success page
            setTimeout(() => { document.getElementById('reminderForm').submit(); }, 1500);
        }

        function toggleProfileDrawer() {
            const drawer = document.getElementById('profileDrawer');
            const backdrop = document.getElementById('profileBackdrop');
            if (drawer.classList.contains('translate-x-full')) {
                backdrop.classList.remove('hidden');
                setTimeout(() => { backdrop.classList.remove('opacity-0'); }, 10);
                drawer.classList.remove('translate-x-full');
            } else {
                backdrop.classList.add('opacity-0');
                drawer.classList.add('translate-x-full');
                setTimeout(() => { backdrop.classList.add('hidden'); }, 300);
            }
        }
    </script>
</body>
</html>