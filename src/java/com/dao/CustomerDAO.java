package com.dao;

import com.model.Customer;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class CustomerDAO {

    public static void updateProfileImage(String userID, InputStream fileContent) throws SQLException, ClassNotFoundException {
        try (Connection con = DBConnection.getConnection();
                PreparedStatement preparedStatement = con.prepareStatement("UPDATE customer SET profileIMG=? WHERE userID=?")) {
            preparedStatement.setBlob(1, fileContent);
            preparedStatement.setString(2, userID);
            preparedStatement.executeUpdate();
        }
    }

    public static InputStream getProfileImage(String userID) throws SQLException, ClassNotFoundException {
        try (Connection con = DBConnection.getConnection();
                PreparedStatement preparedStatement = con.prepareStatement("SELECT profileIMG FROM customer WHERE userID=?")) {
            preparedStatement.setString(1, userID);
            ResultSet rs = preparedStatement.executeQuery();
            if (rs.next()) {
                return rs.getBlob("profileIMG").getBinaryStream();
            } else {
                return null;
            }
        }
    }

    public static Customer getCustomerByID(int userID) throws SQLException, ClassNotFoundException {
        Customer customer = null;
        try (Connection con = DBConnection.getConnection();
                PreparedStatement preparedStatement = con.prepareStatement("SELECT * FROM customer WHERE userID=?")) {
            preparedStatement.setInt(1, userID);
            ResultSet rs = preparedStatement.executeQuery();
            if (rs.next()) {
                customer = new Customer();
                customer.setUserID(rs.getInt("userID"));
                customer.setFirstname(rs.getString("firstname"));
                customer.setLastname(rs.getString("lastname"));
                customer.setProfileImage(rs.getBinaryStream("profileIMG"));
            }
        }
        return customer;
    }
}
