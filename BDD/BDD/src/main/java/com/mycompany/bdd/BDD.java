/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Project/Maven2/JavaApp/src/main/java/${packagePath}/${mainClassName}.java to edit this template
 */

package com.mycompany.bdd;

import java.beans.Statement;
import java.sql.CallableStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Scanner;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.swing.JOptionPane;

/**
 *
 * @author Abarca Romero Jose Angel
 *         Montiel Cruz Angel Leonardo
 *         Ortiz Alvarado Luis Fernando
 */
public class BDD {

    public static void main(String[] args) {
        
        dependeciaPerson conexion1 = new dependeciaPerson();
        dependenciaProduction conexion2 = new dependenciaProduction();
        dependenciaSales conexion3 = new dependenciaSales();
        
        boolean verificacion = true;

        
        conexion1.establecerConexion1();
       // conexion2.establecerConexion2();
       // conexion3.establecerConexion3();
        
        
        
        Scanner datos = new Scanner(System.in);
        int opcion;
        while (true){
            
            System.out.println("------------------------------------------------");
            System.out.println("MENU PARA SELECCIONAR LAS SIGUIENTES CONSULTAS\n");
            
            System.out.println("1. | Consulta A");
            System.out.println("2. | Consulta B");
            System.out.println("3. | Consulta C");
            System.out.println("4. | Consulta D");
            System.out.println("5. | Consulta E");
            System.out.println("6. | Consulta F");
            System.out.println("7. | Consulta G");
            System.out.println("8. | Salir\n");
            
            System.out.print("Elija una de las opciones: ");
            opcion = datos.nextInt();
            
            if (opcion == 1){
                try {
                    CallableStatement consultaA = conexion1.establecerConexion1().prepareCall("{CALL consultaA}");
                    ResultSet rConsultaA = consultaA.executeQuery();
                    System.out.println("PROCEDIMIENTO A\n");
                    System.out.println("Determinar el total de las ventas de los productos con la categoría que se provea\n" +
                                       "de argumento de entrada en la consulta, para cada uno de los territorios\n" +
                                       "registrados en la base de datos.\n");
                    int contador = 0;    
                    System.out.println("TerritoryID | Ventas Totales");
                    System.out.println("----------- | --------------");
                    while (rConsultaA.next()){
                        if (contador == 9)
                            System.out.print(rConsultaA.getString("TerritoryID") + "          | ");
                        else 
                            System.out.print(rConsultaA.getString("TerritoryID") + "           | ");
                        contador ++;
                        System.out.println(rConsultaA.getString("Total_Ventas"));
                    }
                    System.out.println("\n\n");
              
                } 
                catch (SQLException ex) {
                    Logger.getLogger(BDD.class.getName()).log(Level.SEVERE, null, ex);
                }
               
            }
            
            else if (opcion == 2){
            try {
                    CallableStatement consultaA = conexion1.establecerConexion1().prepareCall("{CALL consultaB}");
                    ResultSet rConsultaA = consultaA.executeQuery();
                    System.out.println("PROCEDIMIENTO B\n");
                    System.out.println("Determinar el producto más solicitado para la región (atributo group de\n" +
                                       "salesterritory) “Noth America” y en que territorio de la región tiene mayor\n" +
                                       "demanda\n");   
                    System.out.println("Producto              | Solicitudes | Región");
                    System.out.println("--------------------- | ----------- | ------ ");
                    
                    while (rConsultaA.next()){
                        System.out.print(rConsultaA.getString("Producto") + "   ");
                        System.out.print(rConsultaA.getString("Solicitudes") + "          ");
                        System.out.println(rConsultaA.getString("Region"));
                    }
                    System.out.println("\n\n");
              
                } 
                catch (SQLException ex) {
                    Logger.getLogger(BDD.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
            
            else if (opcion == 3){
                System.out.println("PROCEDIMIENTO C");
            
            }
            
            else if (opcion == 4){
                try {
                    CallableStatement consultaA = conexion1.establecerConexion1().prepareCall("{CALL consultaD}");
                    ResultSet rConsultaA = consultaA.executeQuery();
                    System.out.println("PROCEDIMIENTO D\n");
                    System.out.println("Determinar si hay clientes que realizan ordenes en territorios diferentes al que\n" +
                                       "se encuentran"); 
                 
                    if (rConsultaA == null)
                                System.out.println("No existen clientes que hayan realizado pedidos en territorios distintos");
                    //System.out.println("Producto             | Solicitudes | Región");
                    //System.out.println("-------------------- | ----------- | ----- ");
                    while (rConsultaA.next()){
                   //     System.out.print(rConsultaA.getString("Producto") + "  ");
                    //    System.out.print(rConsultaA.getString("Solicitudes") + " ");
                     //   System.out.println(rConsultaA.getString("Region"));
                          
                    }
                    System.out.println("\n\n");
              
                } 
                catch (SQLException ex) {
                    Logger.getLogger(BDD.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
            
            else if (opcion == 5){
               
            }
            
            else if (opcion == 6){
                System.out.println("PROCEDIMIENTO F");
            
            }
            
            else if (opcion == 7){
                try{
                    System.out.println("PROCEDIMIENTO G\n");
                    System.out.println("Actualizar el correo electrónico de una cliente que se reciba como argumento\n" +
                                       "en la instrucción de actualización.\n"); 
                    Scanner nombreEntrada = new Scanner(System.in);
                    Scanner apellidoEntrada = new Scanner(System.in);
                    Scanner correoEntrada = new Scanner(System.in);
                    
                    System.out.print("Ingrese su nombre: ");
                    String nombre = nombreEntrada.nextLine();
                    System.out.print("Ingrese su apellido: ");
                    String apellido = apellidoEntrada.nextLine();
                    System.out.print("Ingrese su nuevo correo: ");
                    String correo = correoEntrada.nextLine();
                    
                    CallableStatement consultaA = conexion1.establecerConexion1().prepareCall("{CALL consultaG(?,?,?)}");
                    consultaA.setString(1, nombre);
                    consultaA.setString(2, apellido);
                    consultaA.setString(3, correo);
                    
                    ResultSet rConsultaA = consultaA.executeQuery();
                    
                    JOptionPane.showMessageDialog(null, "Se actualizo el nuevo correo.");
                    System.out.println("\n\n");             
                }   
                catch (SQLException ex) {
                    //Logger.getLogger(BDD.class.getName()).log(Level.SEVERE, null, ex);
                    JOptionPane.showMessageDialog(null, "No actualizo el nuevo correo.\n"
                                                           +  "Verifique los datos");
                }
            }
            else 
                break;
        }
    }
}
