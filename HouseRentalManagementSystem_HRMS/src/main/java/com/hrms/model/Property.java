package com.hrms.model;

public class Property {
    private int propertyId;
    private String propertyName;
    private String propertyType;
    private String address;
    private String description;
    private String availabilityStatus;
    private double rentalRate;
    private String city;
    private String postcode;
    private int hoId;

    public Property() {}

    public int getPropertyId() { return propertyId; }
    public void setPropertyId(int propertyId) { this.propertyId = propertyId; }

    public String getPropertyName() { return propertyName; }
    public void setPropertyName(String propertyName) { this.propertyName = propertyName; }

    public String getPropertyType() { return propertyType; }
    public void setPropertyType(String propertyType) { this.propertyType = propertyType; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getAvailabilityStatus() { return availabilityStatus; }
    public void setAvailabilityStatus(String availabilityStatus) { this.availabilityStatus = availabilityStatus; }

    public double getRentalRate() { return rentalRate; }
    public void setRentalRate(double rentalRate) { this.rentalRate = rentalRate; }

    public String getCity() { return city; }
    public void setCity(String city) { this.city = city; }

    public String getPostcode() { return postcode; }
    public void setPostcode(String postcode) { this.postcode = postcode; }

    public int getHoId() { return hoId; }
    public void setHoId(int hoId) { this.hoId = hoId; }
}