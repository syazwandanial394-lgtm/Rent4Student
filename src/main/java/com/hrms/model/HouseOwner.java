package com.hrms.model;

public class HouseOwner {
    private int hoId;
    private String username;
    private String fullName;
    private String email;
    private String password;
    private String phoneNumber;
    private String profileImage;
    
    // Partner's Premium Subscription Variables restored!
    private String subscriptionStatus;
    private String registrationDate;

    // --- Getters and Setters ---
    public int getHoId() { return hoId; }
    public void setHoId(int hoId) { this.hoId = hoId; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getPhoneNumber() { return phoneNumber; }
    public void setPhoneNumber(String phoneNumber) { this.phoneNumber = phoneNumber; }

    public String getProfileImage() { return profileImage; }
    public void setProfileImage(String profileImage) { this.profileImage = profileImage; }

    public String getSubscriptionStatus() { return subscriptionStatus; }
    public void setSubscriptionStatus(String subscriptionStatus) { this.subscriptionStatus = subscriptionStatus; }

    public String getRegistrationDate() { return registrationDate; }
    public void setRegistrationDate(String registrationDate) { this.registrationDate = registrationDate; }
}