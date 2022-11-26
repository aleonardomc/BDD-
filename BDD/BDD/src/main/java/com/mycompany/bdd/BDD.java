/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Project/Maven2/JavaApp/src/main/java/${packagePath}/${mainClassName}.java to edit this template
 */

package com.mycompany.bdd;

import java.beans.Statement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.swing.JOptionPane;

/**
 *
 * @author Abarcar Romero Jose Angel
 *         Montiel Cruz Angel Leonardo
 *         Ortiz Alvarado Luis Fernando
 */
public class BDD {

    public static void main(String[] args) {
        
        dependeciaPerson conexion1 = new dependeciaPerson();
        dependenciaProduction conexion2 = new dependenciaProduction();
        dependenciaSales conexion3 = new dependenciaSales();
        
        conexion1.establecerConexion1();
        conexion2.establecerConexion2();
        conexion3.establecerConexion3();
        
        
    }
}
