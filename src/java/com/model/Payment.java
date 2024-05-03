package com.model;

import java.time.LocalDate;
import java.time.LocalTime;

public class Payment {

    private int quotationId;
    private String paymentMethod;
    private double price;
    private byte[] receiptImage;
    private LocalDate dateSubmitted;
    private LocalTime timeSubmitted;

    // Constructor, getters, and setters
    public Payment(int quotationId, String paymentMethod, double price, byte[] receiptImage, LocalDate dateSubmitted, LocalTime timeSubmitted) {
        this.quotationId = quotationId;
        this.paymentMethod = paymentMethod;
        this.price = price;
        this.receiptImage = receiptImage;
        this.dateSubmitted = dateSubmitted;
        this.timeSubmitted = timeSubmitted;
    }

    // Getters and setters
    public int getQuotationId() {
        return quotationId;
    }

    public void setQuotationId(int quotationId) {
        this.quotationId = quotationId;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public byte[] getReceiptImage() {
        return receiptImage;
    }

    public void setReceiptImage(byte[] receiptImage) {
        this.receiptImage = receiptImage;
    }

    public LocalDate getDateSubmitted() {
        return dateSubmitted;
    }

    public void setDateSubmitted(LocalDate dateSubmitted) {
        this.dateSubmitted = dateSubmitted;
    }

    public LocalTime getTimeSubmitted() {
        return timeSubmitted;
    }

    public void setTimeSubmitted(LocalTime timeSubmitted) {
        this.timeSubmitted = timeSubmitted;
    }
}
