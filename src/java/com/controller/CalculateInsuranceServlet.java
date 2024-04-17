package com.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/calculateInsurance")
public class CalculateInsuranceServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Extract vehicle data from request parameters
        String vehicleMake = request.getParameter("make");
        String vehicleModel = request.getParameter("model");
        int vehicleYear = Integer.parseInt(request.getParameter("year"));

        // Perform calculation
        double insurancePrice = calculateInsurancePrice(vehicleMake, vehicleModel, vehicleYear);

        // Forward the result to the customerQuoPrice.jsp page
        request.setAttribute("insurancePrice", insurancePrice);
        request.getRequestDispatcher("/customerQuoPrice.jsp").forward(request, response);
    }

    // Method to calculate insurance price (sample logic)
    private double calculateInsurancePrice(String make, String model, int year) {
        // Sample calculation logic
        // Replace this with your actual calculation logic
        double basePrice = 500.0;
        double ageFactor = 0.1 * (2024 - year); // Adjust based on the age of the vehicle
        double makeFactor = make.equals("Toyota") ? 1.2 : 1.0; // Adjust based on vehicle make
        double modelFactor = model.contains("SUV") ? 1.3 : 1.0; // Adjust based on vehicle model

        // Calculate total price
        double totalPrice = basePrice * ageFactor * makeFactor * modelFactor;

        return totalPrice;
    }
}
