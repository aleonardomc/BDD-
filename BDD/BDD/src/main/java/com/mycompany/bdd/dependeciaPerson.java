/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.bdd;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import javax.swing.JOptionPane;

/**
 *
 * @author Usuario
 */
class dependeciaPerson {
    
    Connection conexion1 = null;
    String servidor = JOptionPane.showInputDialog("Ingrese el nombre de su servidor: ");
    String user = JOptionPane.showInputDialog("Ingrese su usuario: ");
    String password = JOptionPane.showInputDialog("Ingrese su contraseña: ");
    
    
        String conexion = "jdbc:sqlserver://" + servidor + ":1433;" 
                          + "databaseName=AdventureWorks2019;"
                          + "user=" + user + ";"
                          + "password=" + password + ";"
                          + "loginTimeout=30";
        /*String conexion = "jdbc:sqlserver://ls1-bdd-1.database.windows.net:1433;" 
                          + "databaseName=AW_Person;"
                          + "user=SA_BDD;"
                          + "password=Holacomoestas1;"
                          + "loginTimeout=30";*/
     
    public Connection establecerConexion1(){
        try {
            conexion1 = DriverManager.getConnection(conexion);
            //JOptionPane.showMessageDialog(null, "Conexion establecida con AW_Person");
            return conexion1;
        } 
        catch (SQLException ex) {
            JOptionPane.showMessageDialog(null, ex.toString());
            System.out.println(ex.toString());
            return null;
        }
    }   
}
