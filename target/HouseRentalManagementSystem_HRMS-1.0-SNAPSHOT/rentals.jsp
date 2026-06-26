<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:if test="${empty sessionScope.userRole}">
    <c:redirect url="login.jsp"/>
</c:if>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Rent4Student | Active Rentals</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        @keyframes blob { 0% { transform: translate(0px, 0px) scale(1); } 33% { transform: translate(30px, -50px) scale(1.1); } 66% { transform: translate(-20px, 20px) scale(0.9); } 100% { transform: translate(0px, 0px) scale(1); } }
        .animate-blob { animation: blob 7s infinite; }
        .modal-enter { opacity: 0; transform: scale(0.95); transition: all 0.3s ease-out; }
        .modal-enter-active { opacity: 1; transform: scale(1); }
    </style>
</head>
<body class="bg-slate-50 font-sans text-slate-800 min-h-screen relative overflow-x-hidden overflow-y-scroll">
    <div class="absolute top-40 right-20 w-96 h-96 bg-blue-300 rounded-full mix-blend-multiply filter blur-[120px] opacity-20 animate-blob pointer-events-none z-0"></div>

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
                <a href="rentalController" class="text-orange-500 border-b-2 border-orange-500 pb-1">Rentals</a>
                <c:choose>
                    <c:when test="${sessionScope.userRole == 'student'}"><a href="paymentController" class="border-b-2 border-transparent hover:text-orange-500 transition-colors pb-1">Payments</a></c:when>
                    <c:when test="${sessionScope.userRole == 'owner'}"><a href="paymentController" class="border-b-2 border-transparent hover:text-orange-500 transition-colors pb-1">Revenue</a></c:when>
                </c:choose>
            </div>
            <div class="flex items-center gap-2">
                <div class="hidden md:block text-right mr-2">
                    <p class="text-xs text-slate-400 font-bold uppercase tracking-wider mb-0.5">Welcome,</p>
                    <p class="text-sm font-black text-slate-800 leading-none">
                        <c:choose><c:when test="${sessionScope.userRole == 'admin'}">${sessionScope.adminName}</c:when><c:otherwise>${sessionScope.loggedUser.username}</c:otherwise></c:choose>
                    </p>
                </div>
                <button onclick="toggleProfileDrawer()" class="w-10 h-10 rounded-full bg-gradient-to-tr from-orange-400 to-orange-500 text-white font-black flex items-center justify-center shadow-md hover:shadow-lg hover:scale-105 transition-all outline-none focus:ring-4 focus:ring-orange-200 shrink-0 overflow-hidden border-2 border-white">
                    <c:choose>
                        <c:when test="${sessionScope.userRole == 'admin'}">A</c:when>
                        <c:when test="${not empty sessionScope.loggedUser.profileImage}"><img src="${sessionScope.loggedUser.profileImage}" class="w-full h-full object-cover" alt="Profile"></c:when>
                        <c:otherwise>${sessionScope.loggedUser.fullName.substring(0,1).toUpperCase()}</c:otherwise>
                    </c:choose>
                </button>
            </div>
        </div>
    </nav>

    <main class="max-w-7xl mx-auto px-6 py-12 relative z-10">
        
        <c:if test="${param.success == 'term_req'}">
            <div class="bg-yellow-50 border border-yellow-200 rounded-2xl p-4 mb-6 flex items-center gap-4 shadow-sm">
                <svg class="w-6 h-6 text-yellow-600" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"></path></svg>
                <p class="text-yellow-700 text-sm font-bold">Termination requested successfully. Awaiting house owner approval.</p>
            </div>
        </c:if>
        <c:if test="${param.success == 'term_app'}">
            <div class="bg-green-50 border border-green-200 rounded-2xl p-4 mb-6 flex items-center gap-4 shadow-sm">
                <svg class="w-6 h-6 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path></svg>
                <p class="text-green-700 text-sm font-bold">Lease formally terminated. The property is now available for new students!</p>
            </div>
        </c:if>

        <div class="mb-8">
            <h2 class="text-3xl font-extrabold text-slate-900">Active Rentals</h2>
            <p class="text-slate-500 mt-1">Manage ongoing tenancy agreements.</p>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <c:forEach items="${rentalList}" var="rental">
                <div class="bg-white rounded-3xl p-8 shadow-sm border ${rental.status == 'Termination_Requested' ? 'border-red-200 shadow-red-100' : 'border-slate-100'} relative overflow-hidden transition-all">
                    <c:choose>
                        <c:when test="${rental.status == 'Termination_Requested'}"><div class="absolute top-0 right-0 bg-red-500 text-white text-xs font-black px-4 py-1 rounded-bl-xl">TERMINATION PENDING</div></c:when>
                        <c:otherwise><div class="absolute top-0 right-0 bg-blue-500 text-white text-xs font-black px-4 py-1 rounded-bl-xl">ACTIVE</div></c:otherwise>
                    </c:choose>
                    <h3 class="text-2xl font-bold text-slate-900 mb-4">${rental.propertyName}</h3>
                    <div class="space-y-3 mb-6">
                        <div class="flex justify-between text-sm"><span class="text-slate-500">Tenant:</span><span class="font-bold text-slate-800">${rental.studentName}</span></div>
                        <div class="flex justify-between text-sm"><span class="text-slate-500">Start Date:</span><span class="font-bold text-slate-800">${rental.startDate}</span></div>
                        <div class="flex justify-between text-sm"><span class="text-slate-500">Monthly Rent:</span><span class="font-black text-orange-600">RM ${rental.rentalRate}</span></div>
                    </div>
                    
                    <c:if test="${sessionScope.userRole == 'owner' && rental.status == 'Termination_Requested'}">
                        <div class="bg-red-50 p-4 rounded-xl border border-red-100 mb-6">
                            <p class="text-xs font-bold text-red-500 uppercase mb-1">Reason for Termination</p>
                            <p class="text-sm text-red-900 font-medium italic">"${rental.terminationReason}"</p>
                            <form action="rentalController" method="POST" class="mt-4">
                                <input type="hidden" name="action" value="approveTermination">
                                <input type="hidden" name="rentalId" value="${rental.rentalId}">
                                <input type="hidden" name="propertyId" value="${rental.propertyId}">
                                <button type="submit" class="w-full bg-red-600 hover:bg-red-700 text-white font-bold py-2 rounded-lg transition-colors text-sm shadow-md">Approve & Evict Tenant</button>
                            </form>
                        </div>
                    </c:if>
                    
                    <div class="border-t border-slate-100 pt-6 space-y-3">
                        <button type="button" onclick="openAgreementModal('${rental.rentalId}', '${rental.propertyName}', '${rental.studentName}', '${rental.startDate}', '${empty rental.endDate ? 'Ongoing' : rental.endDate}', '${rental.rentalRate}', '${rental.status}')" class="w-full bg-slate-100 hover:bg-slate-200 text-slate-700 font-bold py-3 rounded-xl transition-colors">View Agreement Details</button>
                    </div>
                </div>
            </c:forEach>
            <c:if test="${empty rentalList}"><div class="col-span-2 bg-white rounded-2xl p-10 text-center border border-slate-100 shadow-sm"><p class="text-slate-500 font-bold text-lg">You have no active rental agreements at this time.</p></div></c:if>
        </div>
    </main>

    <div id="agreementModal" class="fixed inset-0 z-[100] hidden flex items-center justify-center p-4">
        <div class="absolute inset-0 bg-slate-900/60 backdrop-blur-sm" onclick="closeAgreement()"></div>
        <div class="relative bg-white rounded-3xl border border-slate-200 shadow-2xl p-8 w-full max-w-2xl modal-enter max-h-[90vh] overflow-y-auto" id="agreementContent">
            <div class="flex justify-between items-center border-b border-slate-100 pb-4 mb-6">
                <h2 class="text-2xl font-black text-slate-900 flex items-center gap-2"><svg class="w-6 h-6 text-blue-500" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"></path></svg>Digital Tenancy Agreement</h2>
                <button onclick="closeAgreement()" class="text-slate-400 hover:text-red-500 transition-colors"><svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path></svg></button>
            </div>
            <div class="space-y-6 text-sm text-slate-600">
                <p>This document serves as the official digital record of tenancy between the listed parties through the Rent4Student platform.</p>
                <div class="bg-slate-50 rounded-xl p-5 border border-slate-200">
                    <div class="grid grid-cols-2 gap-y-4 gap-x-8">
                        <div><span class="block text-xs font-bold text-slate-400 uppercase">Property</span> <span class="font-bold text-slate-900 text-base" id="modalPropName">--</span></div>
                        <div><span class="block text-xs font-bold text-slate-400 uppercase">Tenant</span> <span class="font-bold text-slate-900 text-base" id="modalTenantName">--</span></div>
                        <div><span class="block text-xs font-bold text-slate-400 uppercase">Commencement Date</span> <span class="font-bold text-slate-900 text-base" id="modalStartDate">--</span></div>
                        <div><span class="block text-xs font-bold text-slate-400 uppercase">End Date</span> <span class="font-bold text-slate-900 text-base" id="modalEndDate">--</span></div>
                        <div class="col-span-2"><span class="block text-xs font-bold text-slate-400 uppercase">Monthly Rent</span> <span class="font-black text-orange-600 text-base" id="modalRent">--</span></div>
                    </div>
                </div>
                <div>
                    <h4 class="font-bold text-slate-900 mb-2">Standard Terms & Conditions</h4>
                    <ul class="list-disc pl-5 space-y-1 text-slate-500">
                        <li>Rent is due on the 1st of every month via the Rent4Student Payment Portal.</li>
                        <li>The tenant agrees to maintain the property in clean and proper condition.</li>
                        <li>Subletting is strictly prohibited without written owner consent.</li>
                        <li>Termination of this agreement requires a 30-day digital notice.</li>
                    </ul>
                </div>
            </div>
            <div class="mt-8 pt-6 border-t border-slate-100 flex justify-between items-center">
                <p class="text-xs text-slate-400 uppercase tracking-widest font-bold">Electronically Verified</p>
                <c:if test="${sessionScope.userRole == 'student'}"><div id="terminateBtnContainer"></div></c:if>
            </div>
        </div>
    </div>

    <div id="termRequestModal" class="fixed inset-0 z-[110] hidden flex items-center justify-center p-4">
        <div class="absolute inset-0 bg-slate-900/60 backdrop-blur-sm" onclick="closeTermRequest()"></div>
        <div class="relative bg-white rounded-3xl border border-slate-200 shadow-2xl p-8 w-full max-w-md modal-enter" id="termRequestContent">
            <h2 class="text-2xl font-black text-slate-900 mb-2">Request Termination</h2>
            <p class="text-slate-500 text-sm mb-6">Please provide a reason for breaking your lease. The house owner must approve this request.</p>
            <form action="rentalController" method="POST">
                <input type="hidden" name="action" value="requestTermination">
                <input type="hidden" name="rentalId" id="termRentalId" value="">
                <textarea name="terminationReason" required rows="4" placeholder="E.g., I have graduated and am moving out of state..." class="w-full bg-slate-50 border border-slate-200 p-4 rounded-xl focus:ring-2 focus:ring-red-500 outline-none text-slate-700 mb-6"></textarea>
                <div class="flex gap-3">
                    <button type="button" onclick="closeTermRequest()" class="w-1/3 bg-white border border-slate-300 hover:bg-slate-50 text-slate-700 font-bold py-3 rounded-xl transition-all shadow-sm">Cancel</button>
                    <button type="submit" class="w-2/3 bg-red-600 hover:bg-red-700 text-white font-bold py-3 rounded-xl shadow-lg transition-all">Submit Request</button>
                </div>
            </form>
        </div>
    </div>

    <div id="profileBackdrop" onclick="toggleProfileDrawer()" class="fixed inset-0 bg-slate-900/40 backdrop-blur-sm z-[100] hidden opacity-0 transition-opacity duration-300"></div>
    <div id="profileDrawer" class="fixed top-0 right-0 h-full w-80 bg-white shadow-2xl z-[101] transform translate-x-full transition-transform duration-300 ease-in-out flex flex-col border-l border-slate-100">
        <div class="p-6 bg-slate-50 border-b border-slate-100 flex justify-between items-start">
            <div class="flex items-center gap-4">
                <div class="w-14 h-14 rounded-full bg-orange-100 text-orange-600 font-black flex items-center justify-center text-2xl shadow-inner overflow-hidden border-2 border-white">
                    <c:choose>
                        <c:when test="${sessionScope.userRole == 'admin'}">A</c:when>
                        <c:when test="${not empty sessionScope.loggedUser.profileImage}"><img src="${sessionScope.loggedUser.profileImage}" class="w-full h-full object-cover" alt="Profile"></c:when>
                        <c:otherwise>${sessionScope.loggedUser.fullName.substring(0,1).toUpperCase()}</c:otherwise>
                    </c:choose>
                </div>
                <div>
                    <p class="font-bold text-slate-900 leading-tight"><c:choose><c:when test="${sessionScope.userRole == 'admin'}">${sessionScope.adminName}</c:when><c:otherwise>${sessionScope.loggedUser.fullName}</c:otherwise></c:choose></p>
                    <p class="text-xs font-bold text-orange-500 uppercase tracking-widest mt-1">${sessionScope.userRole}</p>
                </div>
            </div>
            <button onclick="toggleProfileDrawer()" class="text-slate-400 hover:text-red-500 transition-colors bg-white rounded-full p-1 shadow-sm"><svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path></svg></button>
        </div>
        
        <div class="p-4 flex-1 flex flex-col gap-2 overflow-y-auto">
            <c:choose >
                <c:when test="${sessionScope.userRole == 'owner' and sessionScope.loggedUser.subscriptionStatus == 'Premium'}">
                    <div class="inline-flex items-center gap-3 px-6 py-3.5 bg-gradient-to-r from-yellow-500 via-amber-400 to-yellow-600 text-slate-950 font-black rounded-2xl uppercase tracking-wider text-xs shadow-xl shadow-amber-500/20 border border-yellow-300/40 transform transition-all duration-200">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 text-slate-950" viewBox="0 0 24 24" fill="currentColor">
                            <path d="M12 2L15.09 8.26L22 9.27L17 14.14L18.18 21.02L12 17.77L5.82 21.02L7 14.14L2 9.27L8.91 8.26L12 2Z"></path>
                        </svg>
                        Premium Owner Unlocked
                    </div>
                </c:when>
                <c:when test="${sessionScope.userRole == 'owner' and sessionScope.loggedUser.subscriptionStatus == 'Pro'}">
                    <div class="inline-flex items-center gap-3 px-6 py-3.5 bg-gradient-to-r from-gray-100 via-gray-300 to-gray-600 text-slate-950 font-white rounded-2xl uppercase tracking-wider text-xs shadow-xl shadow-silver-500/20 border border-yellow-300/40 transform transition-all duration-200">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 text-slate-950" viewBox="0 0 24 24" fill="currentColor">
                            <path d="M12 2L15.09 8.26L22 9.27L17 14.14L18.18 21.02L12 17.77L5.82 21.02L7 14.14L2 9.27L8.91 8.26L12 2Z"></path>
                        </svg>
                        Pro Owner Unlocked
                    </div>
                </c:when>
                <c:when test="${sessionScope.userRole == 'owner' and sessionScope.loggedUser.subscriptionStatus == 'Standard'}">
                    <div class="inline-flex items-center gap-3 px-6 py-3.5 bg-gradient-to-r from-gray-200 via-glate-800 to-gray-200 text-slate-950 font-black rounded-2xl uppercase tracking-wider text-xs shadow-xl shadow-slate-500/20 border border-yellow-300/40 transform transition-all duration-200">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 text-slate-950" viewBox="0 0 24 24" fill="currentColor">
                            <path d="M12 2L15.09 8.26L22 9.27L17 14.14L18.18 21.02L12 17.77L5.82 21.02L7 14.14L2 9.27L8.91 8.26L12 2Z"></path>
                        </svg>
                        Standard Ownership
                    </div>
                </c:when>
                <c:when test="${sessionScope.userRole == 'owner' and sessionScope.loggedUser.subscriptionStatus == 'Free'}">
                    <a href="subscribe.jsp" class="flex items-center gap-3 p-3 rounded-xl bg-gradient-to-r from-orange-500 to-orange-600 hover:from-orange-400 hover:to-orange-500 text-white font-bold transition-all shadow-lg shadow-orange-500/20 hover:shadow-orange-500/40 transform hover:-translate-y-0.5 group">
                        <div class="w-8 h-8 rounded-lg bg-white/20 text-white group-hover:bg-white group-hover:text-orange-600 flex items-center justify-center transition-all duration-200">
                            <svg class="w-4 h-4" fill="currentColor" viewBox="0 0 24 24">
                                <path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"></path>
                            </svg>
                        </div>
                        <span class="tracking-wide">Upgrade to Premium</span>
                    </a>
                </c:when>
            </c:choose>
            
            <a href="profileController" class="flex items-center gap-3 p-3 rounded-xl hover:bg-slate-100 text-slate-700 hover:text-slate-900 font-bold transition-all group">
                <div class="w-8 h-8 rounded-lg bg-slate-100 text-slate-500 group-hover:bg-slate-200 group-hover:text-slate-700 flex items-center justify-center transition-colors"><svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"></path></svg></div> My Profile Settings
            </a>
            
            <c:if test="${sessionScope.userRole == 'owner'}">
                <a href="properties" class="flex items-center gap-3 p-3 rounded-xl hover:bg-slate-100 text-slate-700 hover:text-slate-900 font-bold transition-all group">
                    <div class="w-8 h-8 rounded-lg bg-slate-100 text-slate-500 group-hover:bg-slate-200 group-hover:text-slate-700 flex items-center justify-center transition-colors"><svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"></path></svg></div> My Properties
                </a>
                
                <a href="rentalController?action=duePayments" class="flex items-center gap-3 p-3 rounded-xl hover:bg-slate-100 text-slate-700 hover:text-slate-900 font-bold transition-all group">
                    <div class="w-8 h-8 rounded-lg bg-slate-100 text-slate-500 group-hover:bg-slate-200 group-hover:text-slate-700 flex items-center justify-center transition-colors"><svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg></div> Due Payments
                </a>
            </c:if>
            
            <a href="reportController?action=viewTickets" class="flex items-center gap-3 p-3 rounded-xl hover:bg-slate-100 text-slate-700 hover:text-slate-900 font-bold transition-all group">
                <div class="w-8 h-8 rounded-lg bg-slate-100 text-slate-500 group-hover:bg-slate-200 group-hover:text-slate-700 flex items-center justify-center transition-colors"><svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 10h.01M12 10h.01M16 10h.01M9 16H5a2 2 0 01-2-2V6a2 2 0 012-2h14a2 2 0 012 2v8a2 2 0 01-2 2h-5l-5 5v-5z"></path></svg></div> My Support Tickets
            </a>
        </div>
        
        <div class="p-6 border-t border-slate-100 bg-slate-50">
            <form id="logoutFormDrawer" action="auth" method="POST" class="m-0">
                <input type="hidden" name="action" value="logout">
                <button type="submit" class="w-full flex items-center justify-center gap-2 bg-white border border-red-200 text-red-600 hover:bg-red-50 hover:border-red-300 font-bold py-3 rounded-xl shadow-sm transition-all"><svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1"></path></svg>Secure Logout</button>
            </form>
        </div>
    </div>
    
    <script>
        const agModal = document.getElementById('agreementModal');
        const agContent = document.getElementById('agreementContent');
        const tBtnContainer = document.getElementById('terminateBtnContainer');
        
        function openAgreementModal(rentalId, propName, tenantName, startDate, endDate, rent, status) {
            document.getElementById('modalPropName').innerText = propName;
            document.getElementById('modalTenantName').innerText = tenantName;
            document.getElementById('modalStartDate').innerText = startDate;
            document.getElementById('modalEndDate').innerText = endDate;
            document.getElementById('modalRent').innerText = "RM " + rent;
            if(tBtnContainer) {
                if(status === 'Active') {
                    tBtnContainer.innerHTML = `<button type="button" onclick="openTermRequest('`+rentalId+`')" class="bg-red-50 text-red-600 hover:bg-red-100 font-bold py-2 px-4 rounded-lg text-sm transition-colors border border-red-200">Request Lease Termination</button>`;
                } else if (status === 'Termination_Requested') {
                    tBtnContainer.innerHTML = `<span class="bg-red-100 text-red-700 font-bold px-4 py-2 rounded-lg text-sm">Termination Pending Owner Approval...</span>`;
                }
            }
            agModal.classList.remove('hidden');
            setTimeout(() => { agContent.classList.add('modal-enter-active'); }, 10);
        }
        function closeAgreement() {
            agContent.classList.remove('modal-enter-active');
            setTimeout(() => { agModal.classList.add('hidden'); }, 300);
        }

        const tReqModal = document.getElementById('termRequestModal');
        const tReqContent = document.getElementById('termRequestContent');
        function openTermRequest(rentalId) {
            closeAgreement();
            document.getElementById('termRentalId').value = rentalId;
            tReqModal.classList.remove('hidden');
            setTimeout(() => { tReqContent.classList.add('modal-enter-active'); }, 10);
        }
        function closeTermRequest() {
            tReqContent.classList.remove('modal-enter-active');
            setTimeout(() => { tReqModal.classList.add('hidden'); }, 300);
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