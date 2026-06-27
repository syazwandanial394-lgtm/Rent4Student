<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:if test="${empty sessionScope.userRole}">
    <c:redirect url="login.jsp"/>
</c:if>
<c:if test="${param.success == 'deleted'}">
    <div class="bg-green-50 border border-green-200 rounded-xl p-4 mb-6 text-center text-sm font-bold text-green-700">
        Your account and all associated data have been permanently deleted.
    </div>
</c:if>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Rent4Student | My Profile</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        @keyframes blob { 0% { transform: translate(0px, 0px) scale(1); } 33% { transform: translate(30px, -50px) scale(1.1); } 66% { transform: translate(-20px, 20px) scale(0.9); } 100% { transform: translate(0px, 0px) scale(1); } }
        .animate-blob { animation: blob 7s infinite; }
        .animation-delay-2000 { animation-delay: 2s; }
        .modal-enter { opacity: 0; transform: scale(0.95); transition: all 0.3s ease-out; }
        .modal-enter-active { opacity: 1; transform: scale(1); }
    </style>
</head>
<body class="bg-slate-50 font-sans text-slate-800 min-h-screen relative overflow-x-hidden overflow-y-scroll">

    <div class="absolute top-0 left-20 w-96 h-96 bg-orange-300 rounded-full mix-blend-multiply filter blur-[120px] opacity-20 animate-blob pointer-events-none z-0"></div>
    <div class="absolute top-40 right-20 w-96 h-96 bg-blue-300 rounded-full mix-blend-multiply filter blur-[120px] opacity-20 animate-blob animation-delay-2000 pointer-events-none z-0"></div>

    <nav class="bg-white/80 backdrop-blur-md border-b border-slate-200 sticky top-0 z-50 shadow-sm relative z-[60]">
        <div class="max-w-7xl mx-auto px-6 py-3 flex justify-between items-center">
            <div class="flex items-center gap-2">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-8 w-8 text-orange-500" viewBox="0 0 24 24" fill="currentColor"><path d="M12 3L1 9l4 2.18v6L12 21l7-3.82v-6l2-1.09V17h2V9L12 3zm6.82 6L12 12.72 5.18 9 12 5.28 18.82 9zM17 15.99l-5 2.73-5-2.73v-3.72l5 2.73 5-2.73v3.72z"/></svg>
                <h1 class="text-2xl font-black text-slate-900 tracking-tight">Rent<span class="text-orange-500">4</span>Student</h1>
            </div>
            
            <div class="hidden md:flex gap-6 text-sm font-bold text-slate-600">
                <a href="dashboard" class="nav-link hover:text-orange-500 transition-colors pb-1">Dashboard</a>
                <a href="properties" class="nav-link hover:text-orange-500 transition-colors pb-1">Properties</a>
                <a href="applicationController" class="nav-link hover:text-orange-500 transition-colors pb-1">Applications</a>
                <a href="rentalController" class="nav-link hover:text-orange-500 transition-colors pb-1">Rentals</a>
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

    <main class="max-w-3xl mx-auto px-6 py-12 relative z-10">
        <c:if test="${param.error == 'true' || param.error == 'delete_failed'}">
            <div class="bg-red-50 border border-red-200 rounded-2xl p-4 mb-6 flex items-center gap-4 shadow-sm">
                <svg class="w-6 h-6 text-red-600" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
                <p class="text-red-700 text-sm font-bold">Action failed. Please try again or contact support.</p>
            </div>
        </c:if>

        <div id="profileSummaryView" class="transition-all duration-300 ${param.error == 'true' ? 'hidden' : ''}">
            <div class="bg-white rounded-3xl shadow-sm border border-slate-100 p-8">
                <div class="flex justify-between items-start mb-8 border-b border-slate-100 pb-6">
                    <div class="flex items-center gap-4">
                        <div class="w-16 h-16 bg-orange-100 text-orange-500 rounded-full flex items-center justify-center text-2xl font-black uppercase shadow-inner overflow-hidden border-2 border-white">
                            <c:choose>
                                <c:when test="${not empty sessionScope.loggedUser.profileImage}"><img src="${sessionScope.loggedUser.profileImage}" class="w-full h-full object-cover" alt="Profile"></c:when>
                                <c:otherwise>${sessionScope.loggedUser.fullName.substring(0,1).toUpperCase()}</c:otherwise>
                            </c:choose>
                        </div>
                        <div>
                            <h2 class="text-2xl font-extrabold text-slate-900">Profile Summary</h2>
                            <p class="text-slate-500 text-sm">Your official digital record on Rent4Student.</p>
                        </div>
                    </div>
                    <button onclick="toggleEditMode(true)" class="bg-slate-100 hover:bg-slate-200 text-slate-700 font-bold py-2 px-6 rounded-xl text-sm transition-colors flex items-center gap-2 shadow-sm">
                        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15.232 5.232l3.536 3.536m-2.036-5.036a2.5 2.5 0 113.536 3.536L6.5 21.036H3v-3.572L16.732 3.732z"></path></svg>
                        Edit Profile
                    </button>
                </div>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-y-6 gap-x-8 bg-slate-50 rounded-2xl p-6 border border-slate-100">
                    <div>
                        <span class="block text-xs font-bold text-slate-400 uppercase tracking-wider mb-1">Username</span>
                        <span class="font-bold text-slate-900 text-lg">${empty sessionScope.loggedUser.username ? '<em class="text-slate-300 font-normal">Not Set</em>' : sessionScope.loggedUser.username}</span>
                    </div>
                    <div>
                        <span class="block text-xs font-bold text-slate-400 uppercase tracking-wider mb-1">Full Name</span>
                        <span class="font-bold text-slate-900 text-lg">${sessionScope.loggedUser.fullName}</span>
                    </div>
                    <div>
                        <span class="block text-xs font-bold text-slate-400 uppercase tracking-wider mb-1">Email Address</span>
                        <span class="font-bold text-slate-900 text-lg">${sessionScope.loggedUser.email}</span>
                    </div>
                    <div>
                        <span class="block text-xs font-bold text-slate-400 uppercase tracking-wider mb-1">Phone Number</span>
                        <span class="font-bold text-slate-900 text-lg">${empty sessionScope.loggedUser.phoneNumber ? '<em class="text-slate-300 font-normal">Not Set</em>' : sessionScope.loggedUser.phoneNumber}</span>
                    </div>
                    <c:if test="${sessionScope.userRole == 'student'}">
                        <div class="md:col-span-2 border-t border-slate-200 pt-6 mt-2"></div>
                        <div>
                            <span class="block text-xs font-bold text-slate-400 uppercase tracking-wider mb-1">University</span>
                            <span class="font-bold text-slate-900 text-lg">${empty sessionScope.loggedUser.university ? '<em class="text-slate-300 font-normal">Not Set</em>' : sessionScope.loggedUser.university}</span>
                        </div>
                        <div>
                            <span class="block text-xs font-bold text-slate-400 uppercase tracking-wider mb-1">Faculty / Course</span>
                            <span class="font-bold text-slate-900 text-lg">${empty sessionScope.loggedUser.faculty ? '<em class="text-slate-300 font-normal">Not Set</em>' : sessionScope.loggedUser.faculty}</span>
                        </div>
                        <div class="md:col-span-2">
                            <span class="block text-xs font-bold text-slate-400 uppercase tracking-wider mb-1">Preferred Location</span>
                            <span class="font-bold text-slate-900 text-lg">${empty sessionScope.loggedUser.preferredLocation ? '<em class="text-slate-300 font-normal">Not Set</em>' : sessionScope.loggedUser.preferredLocation}</span>
                        </div>
                    </c:if>
                </div>
            </div>

            <c:if test="${sessionScope.userRole == 'student'}">
                <div class="mt-8 bg-white rounded-3xl shadow-sm border border-red-100 p-8 flex flex-col md:flex-row items-center justify-between gap-6 overflow-hidden relative">
                    <div class="absolute left-0 top-0 w-2 h-full bg-red-500"></div>
                    <div>
                        <h3 class="text-xl font-black text-red-600 mb-1">Danger Zone</h3>
                        <p class="text-slate-500 text-sm">Permanently delete your profile and remove your data from the system.</p>
                    </div>
                    <button type="button" onclick="openDeleteModal()" class="shrink-0 bg-red-50 hover:bg-red-600 text-red-600 hover:text-white font-bold py-3 px-6 rounded-xl transition-all border border-red-200 hover:border-red-600 shadow-sm">
                        Delete Account
                    </button>
                </div>
            </c:if>
        </div>

        <div id="profileEditView" class="bg-white rounded-3xl shadow-xl border border-orange-100 p-8 transition-all duration-300 ${param.error == 'true' ? '' : 'hidden'}">
            <div class="flex items-center gap-4 mb-8 border-b border-slate-100 pb-6">
                <div class="w-16 h-16 bg-orange-500 text-white rounded-full flex items-center justify-center text-2xl font-black uppercase shadow-md overflow-hidden">
                    <c:choose>
                        <c:when test="${not empty sessionScope.loggedUser.profileImage}"><img src="${sessionScope.loggedUser.profileImage}" class="w-full h-full object-cover" alt="Profile"></c:when>
                        <c:otherwise>${sessionScope.loggedUser.fullName.substring(0,1).toUpperCase()}</c:otherwise>
                    </c:choose>
                </div>
                <div>
                    <h2 class="text-2xl font-extrabold text-slate-900">Edit Details</h2>
                    <p class="text-orange-600 text-sm font-bold">Update your personal and contact info below.</p>
                </div>
            </div>

            <form id="editProfileForm" action="profileController" method="POST" enctype="multipart/form-data" class="space-y-6">
                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <div class="md:col-span-2">
                        <label class="block text-xs font-bold text-slate-500 uppercase mb-2">Update Profile Picture</label>
                        <input type="file" name="profileImage" accept="image/*" class="track-input w-full bg-slate-50 border border-slate-200 text-slate-400 p-2 rounded-xl focus:ring-2 focus:ring-orange-500 outline-none file:mr-4 file:py-2 file:px-4 file:rounded-full file:border-0 file:text-xs file:font-bold file:bg-orange-500 file:text-white hover:file:bg-orange-600 transition-all cursor-pointer">
                    </div>
                    <div><label class="block text-xs font-bold text-slate-500 uppercase mb-2">Username</label><input type="text" name="username" value="${sessionScope.loggedUser.username}" required class="track-input w-full bg-slate-50 border border-slate-200 text-slate-800 p-3 rounded-xl focus:ring-2 focus:ring-orange-500 outline-none transition-all"></div>
                    <div><label class="block text-xs font-bold text-slate-500 uppercase mb-2">Full Name</label><input type="text" name="fullName" value="${sessionScope.loggedUser.fullName}" required class="track-input w-full bg-slate-50 border border-slate-200 text-slate-800 p-3 rounded-xl focus:ring-2 focus:ring-orange-500 outline-none transition-all"></div>
                    <div><label class="block text-xs font-bold text-slate-500 uppercase mb-2">Email Address</label><input type="email" name="email" value="${sessionScope.loggedUser.email}" required class="track-input w-full bg-slate-50 border border-slate-200 text-slate-800 p-3 rounded-xl focus:ring-2 focus:ring-orange-500 outline-none transition-all"></div>
                    <div><label class="block text-xs font-bold text-slate-500 uppercase mb-2">Phone Number</label><input type="text" name="phoneNumber" value="${sessionScope.loggedUser.phoneNumber}" required class="track-input w-full bg-slate-50 border border-slate-200 text-slate-800 p-3 rounded-xl focus:ring-2 focus:ring-orange-500 outline-none transition-all"></div>
                    
                    <c:if test="${sessionScope.userRole == 'student'}">
                        <div><label class="block text-xs font-bold text-slate-500 uppercase mb-2">University</label><input type="text" name="university" value="${sessionScope.loggedUser.university}" required class="track-input w-full bg-slate-50 border border-slate-200 text-slate-800 p-3 rounded-xl focus:ring-2 focus:ring-orange-500 outline-none transition-all"></div>
                        <div><label class="block text-xs font-bold text-slate-500 uppercase mb-2">Faculty / Course</label><input type="text" name="faculty" value="${sessionScope.loggedUser.faculty}" placeholder="e.g. Faculty of Computing" class="track-input w-full bg-slate-50 border border-slate-200 text-slate-800 p-3 rounded-xl focus:ring-2 focus:ring-orange-500 outline-none transition-all"></div>
                        <div class="md:col-span-2"><label class="block text-xs font-bold text-slate-500 uppercase mb-2">Preferred Location</label><input type="text" name="preferredLocation" value="${sessionScope.loggedUser.preferredLocation}" placeholder="e.g. Gong Badak" class="track-input w-full bg-slate-50 border border-slate-200 text-slate-800 p-3 rounded-xl focus:ring-2 focus:ring-orange-500 outline-none transition-all"></div>
                    </c:if>
                </div>

                <div class="pt-4 flex justify-end gap-3 border-t border-slate-100 mt-6">
                    <button type="button" onclick="cancelEdit()" class="bg-white border border-slate-300 hover:bg-slate-50 text-slate-700 font-bold py-3 px-6 rounded-xl transition-all shadow-sm">Cancel</button>
                    <button type="submit" onclick="allowSubmit()" class="bg-gradient-to-r from-orange-500 to-orange-600 hover:from-orange-400 hover:to-orange-500 text-white font-bold py-3 px-8 rounded-xl shadow-lg transition-all">Save Changes</button>
                </div>
            </form>
        </div>
    </main>

    <c:if test="${param.success == 'true'}">
        <div id="successModal" class="fixed inset-0 z-[110] flex items-center justify-center p-4">
            <div class="absolute inset-0 bg-slate-900/60 backdrop-blur-sm" onclick="closeSuccessModal()"></div>
            <div class="relative bg-white rounded-3xl border border-slate-200 shadow-2xl p-10 w-full max-w-sm text-center modal-enter-active" id="successContent">
                <div class="w-20 h-20 bg-green-100 text-green-500 rounded-full flex items-center justify-center mx-auto mb-6 shadow-inner"><svg class="w-10 h-10" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path></svg></div>
                <h2 class="text-2xl font-black text-slate-900 tracking-tight mb-2">Profile Updated!</h2>
                <p class="text-slate-500 text-sm mb-8">Your account details have been successfully saved and synced.</p>
                <button onclick="closeSuccessModal()" class="w-full bg-slate-100 hover:bg-slate-200 text-slate-800 font-bold py-3 rounded-xl transition-colors">Awesome</button>
            </div>
        </div>
        <script>
            function closeSuccessModal() {
                document.getElementById('successContent').classList.remove('modal-enter-active');
                setTimeout(() => { document.getElementById('successModal').classList.add('hidden'); }, 300);
            }
        </script>
    </c:if>

    <div id="unsavedModal" class="fixed inset-0 z-[120] hidden flex items-center justify-center p-4">
        <div class="absolute inset-0 bg-slate-900/60 backdrop-blur-sm"></div>
        <div class="relative bg-white rounded-3xl border border-slate-200 shadow-2xl p-8 w-full max-w-sm text-center modal-enter" id="unsavedContent">
            <div class="w-16 h-16 bg-yellow-100 text-yellow-500 rounded-full flex items-center justify-center mx-auto mb-4"><svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"></path></svg></div>
            <h2 class="text-xl font-black text-slate-900 tracking-tight mb-2">Unsaved Changes</h2>
            <p class="text-slate-500 text-sm mb-6">You have edited your profile but haven't saved it. If you leave now, your changes will be lost.</p>
            <div class="flex gap-3">
                <button onclick="proceedNavigation()" class="w-1/2 bg-red-50 hover:bg-red-100 text-red-600 font-bold py-3 rounded-xl transition-colors text-sm">Discard</button>
                <button onclick="closeUnsavedModal()" class="w-1/2 bg-slate-900 hover:bg-slate-800 text-white font-bold py-3 rounded-xl transition-colors text-sm shadow-md">Keep Editing</button>
            </div>
        </div>
    </div>

    <div id="deleteModal" class="fixed inset-0 z-[130] hidden flex items-center justify-center p-4">
        <div class="absolute inset-0 bg-slate-900/80 backdrop-blur-md" onclick="closeDeleteModal()"></div>
        <div class="relative bg-white rounded-3xl border border-red-200 shadow-2xl p-8 w-full max-w-md text-center modal-enter" id="deleteContent">
            <div class="w-20 h-20 bg-red-100 text-red-600 rounded-full flex items-center justify-center mx-auto mb-4 border-4 border-white shadow-sm">
                <svg class="w-10 h-10" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"></path></svg>
            </div>
            <h2 class="text-2xl font-black text-slate-900 tracking-tight mb-2">Delete Account?</h2>
            <p class="text-slate-500 text-sm mb-6">This will permanently remove your profile, applications, and rental history from Rent4Student. <b>This action cannot be undone.</b></p>
            <form action="profileController" method="POST" class="flex gap-3">
                <input type="hidden" name="action" value="deleteAccount">
                <button type="button" onclick="closeDeleteModal()" class="w-1/2 bg-white border border-slate-300 hover:bg-slate-50 text-slate-700 font-bold py-3 rounded-xl transition-all shadow-sm">Cancel</button>
                <button type="submit" onclick="allowSubmit()" class="w-1/2 bg-red-600 hover:bg-red-700 text-white font-bold py-3 rounded-xl shadow-lg transition-all">Yes, Delete It</button>
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
            <c:choose>
                <c:when test="${sessionScope.userRole == 'owner' and sessionScope.loggedUser.subscriptionStatus == 'Premium'}">
                    <div class="inline-flex items-center gap-3 px-6 py-3.5 bg-gradient-to-r from-yellow-500 via-amber-400 to-yellow-600 text-slate-950 font-black rounded-2xl uppercase tracking-wider text-xs shadow-xl shadow-amber-500/20 border border-yellow-300/40 transform hover:scale-[1.02] transition-all duration-200 mb-2">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 text-slate-950" viewBox="0 0 24 24" fill="currentColor"><path d="M12 2L15.09 8.26L22 9.27L17 14.14L18.18 21.02L12 17.77L5.82 21.02L7 14.14L2 9.27L8.91 8.26L12 2Z"></path></svg> Premium Owner Unlocked
                    </div>
                </c:when>
                <c:when test="${sessionScope.userRole == 'owner' and sessionScope.loggedUser.subscriptionStatus == 'Free'}">
                    <a href="subscribe.jsp" class="nav-link flex items-center gap-3 p-3 rounded-xl bg-gradient-to-r from-orange-500 to-orange-600 hover:from-orange-400 hover:to-orange-500 text-white font-bold transition-all shadow-lg shadow-orange-500/20 hover:shadow-orange-500/40 transform hover:-translate-y-0.5 group mb-2">
                        <div class="w-8 h-8 rounded-lg bg-white/20 text-white group-hover:bg-white group-hover:text-orange-600 flex items-center justify-center transition-all duration-200"><svg class="w-4 h-4" fill="currentColor" viewBox="0 0 24 24"><path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"></path></svg></div>
                        <span class="tracking-wide">Upgrade to Premium</span>
                    </a>
                </c:when>
            </c:choose>
            <a href="profileController" class="nav-link flex items-center gap-3 p-3 rounded-xl bg-orange-50 text-orange-600 font-bold transition-all group">
                <div class="w-8 h-8 rounded-lg bg-orange-100 text-orange-500 flex items-center justify-center transition-colors"><svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"></path></svg></div> My Profile Settings
            </a>
            <c:if test="${sessionScope.userRole == 'owner'}">
                <a href="properties" class="flex items-center gap-3 p-3 rounded-xl hover:bg-slate-100 text-slate-700 hover:text-slate-900 font-bold transition-all group">
                    <div class="w-8 h-8 rounded-lg bg-slate-100 text-slate-500 group-hover:bg-slate-200 group-hover:text-slate-700 flex items-center justify-center transition-colors">
                        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"></path></svg>
                    </div> My Properties
                </a>
            </c:if>
            <c:if test="${sessionScope.userRole == 'owner'}">
                <a href="rentalController?action=duePayments" class="flex items-center gap-3 p-3 rounded-xl hover:bg-slate-100 text-slate-700 hover:text-slate-900 font-bold transition-all group">
                    <div class="w-8 h-8 rounded-lg bg-slate-100 text-slate-500 group-hover:bg-slate-200 group-hover:text-slate-700 flex items-center justify-center transition-colors"><svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg></div> Due Payments
                </a>
            </c:if>
            <a href="reportController?action=viewTickets" class="nav-link flex items-center gap-3 p-3 rounded-xl hover:bg-slate-100 text-slate-700 hover:text-slate-900 font-bold transition-all group">
                <div class="w-8 h-8 rounded-lg bg-slate-100 text-slate-500 group-hover:bg-slate-200 group-hover:text-slate-700 flex items-center justify-center transition-colors"><svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 10h.01M12 10h.01M16 10h.01M9 16H5a2 2 0 01-2-2V6a2 2 0 012-2h14a2 2 0 012 2v8a2 2 0 01-2 2h-5l-5 5v-5z"></path></svg></div> My Support Tickets
            </a>
        </div>
        <div class="p-6 border-t border-slate-100 bg-slate-50">
            <form id="logoutFormDrawer" action="auth" method="POST" class="m-0">
                <input type="hidden" name="action" value="logout">
                <button type="button" onclick="handleLogout()" class="w-full flex items-center justify-center gap-2 bg-white border border-red-200 text-red-600 hover:bg-red-50 hover:border-red-300 font-bold py-3 rounded-xl shadow-sm transition-all"><svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1"></path></svg>Secure Logout</button>
            </form>
        </div>
    </div>

    <script>
        let isDirty = false;
        let pendingAction = null; 
        let isSubmitting = false; 

        document.querySelectorAll('.track-input').forEach(input => {
            input.addEventListener('input', () => { isDirty = true; });
        });

        function allowSubmit() { isSubmitting = true; }

        function cancelEdit() {
            if (isDirty) {
                pendingAction = () => {
                    document.getElementById('editProfileForm').reset();
                    isDirty = false; 
                    toggleEditMode(false);
                };
                showUnsavedModal();
            } else {
                toggleEditMode(false);
            }
        }

        document.querySelectorAll('.nav-link').forEach(link => {
            link.addEventListener('click', function(e) {
                if (isDirty && !isSubmitting) {
                    e.preventDefault();
                    pendingAction = () => { window.location.href = this.href; };
                    showUnsavedModal();
                }
            });
        });

        function handleLogout() {
            if(isDirty && !isSubmitting) {
                pendingAction = () => { document.getElementById('logoutFormDrawer').submit(); };
                showUnsavedModal();
            } else {
                document.getElementById('logoutFormDrawer').submit();
            }
        }

        function showUnsavedModal() {
            document.getElementById('unsavedModal').classList.remove('hidden');
            setTimeout(() => { document.getElementById('unsavedContent').classList.add('modal-enter-active'); }, 10);
        }

        function closeUnsavedModal() {
            document.getElementById('unsavedContent').classList.remove('modal-enter-active');
            setTimeout(() => { document.getElementById('unsavedModal').classList.add('hidden'); }, 300);
            pendingAction = null; 
        }

        function proceedNavigation() {
            if (pendingAction) {
                let actionToExecute = pendingAction; 
                document.getElementById('unsavedContent').classList.remove('modal-enter-active');
                document.getElementById('unsavedModal').classList.add('hidden');
                actionToExecute(); 
                pendingAction = null; 
            } else {
                closeUnsavedModal();
            }
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

        function toggleEditMode(showEdit) {
            if (showEdit) {
                document.getElementById('profileSummaryView').classList.add('hidden');
                document.getElementById('profileEditView').classList.remove('hidden');
            } else {
                document.getElementById('profileEditView').classList.add('hidden');
                document.getElementById('profileSummaryView').classList.remove('hidden');
            }
        }

        function openDeleteModal() {
            document.getElementById('deleteModal').classList.remove('hidden');
            setTimeout(() => { document.getElementById('deleteContent').classList.add('modal-enter-active'); }, 10);
        }

        function closeDeleteModal() {
            document.getElementById('deleteContent').classList.remove('modal-enter-active');
            setTimeout(() => { document.getElementById('deleteModal').classList.add('hidden'); }, 300);
        }
    </script>
</body>
</html>