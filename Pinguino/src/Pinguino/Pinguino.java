/* -------  Pinguino Processing  1.0   --------
 *
 * @author Yohon Jairo Bravo Castro
 * Email: bravo2008@misena.edu.co
 *
 *
 *
 * Libreria para Processing 1.3 para uso con Pinguino y su bootloader 4.14
 *
 *
 * Esta Librería esta basada en la libreria creada por Jean-Pierre Mandon, Douglas Edric Stanley & Stéphane Cousot 
 * Actualizada para ser usada con la versión 1.3 de Processing y Pinguino 2550 con bootloader 4.14.
 * Compilada con Java 8 en 2016.
 *
 * URL: https://github.com/PinguinoIDE/PinguinoProcessing
 *
 *
 * LIBRERIAS 
 *
 * libusb4java-1.2.0
 * usb4java-1.2.0
 * http://usb4java.org/
 *
 *
 * LICENCIA
 *
 * This library is free software: you can redistribute it and/or modify it under the 
 * terms of the GNU Lesser General Public License as published by the Free Software Foundation,
 * either version 3 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
 * without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. 
 * See the GNU Lesser General Public License for more details. 
 *
 */

package Pinguino;

import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.nio.IntBuffer;
import processing.core.PApplet;

import java.util.concurrent.TimeUnit;
import org.usb4java.BufferUtils;
import org.usb4java.DeviceHandle;
import org.usb4java.LibUsb;
import org.usb4java.LibUsbException;


public class Pinguino extends Exception {

    private final static int VID = 0x04D8;
    private final static int PID = 0xFEAA;
    private static final byte INTERFACE = 1;

    public static boolean LOGGER = false;

    private static final int TIMEOUT = 5000;

    private static final byte OUT_ENDPOINT = 0x01;
    private static final byte IN_ENDPOINT = (byte) 0x81; //bootloader V4 pinguino 2550 

    /**
     * Digital pin status.
     */
    public final int HIGH = 1;
    public final int LOW = 0;

    /**
     * Processing applet object
     */
    PApplet parent;
    /**
     *
     * The last error message
     */
    public static String errmsg = "";

    DeviceHandle handle;

    public Pinguino() {

        this(null);

    }

    /**
     *
     * @param parent
     */
    public Pinguino(PApplet parent) {
        super();
        
        this.parent = parent;
        // update paths and register this object to the PApplet,
        // while this library is used with Processing

        this.parent.registerMethod("dispose", this);
        int result = LibUsb.init(null);
        if (result != LibUsb.SUCCESS) {
            throw new LibUsbException("Unable to initialize libusb", result);
        } else {

            printOut("Conexión a Pinguino exitosa");
        }

        // Open test device (Samsung Galaxy Nexus)
        handle = LibUsb.openDeviceWithVidPid(null, (short) VID, (short) PID);
        if (handle == null) {

            printOut("Conexión a Pinguino no funciona -> Vendor ID " + VID + " Product ID " + PID);
            System.exit(1);
        } else {

        }
        boolean detach = (LibUsb.kernelDriverActive(handle, 0) == 1);
        if (detach) {

            // Claim the ADB interface
            result = LibUsb.claimInterface(handle, INTERFACE);
            if (result != LibUsb.SUCCESS) {
                throw new LibUsbException("Unable to claim interface", result);
            }
        }

    }

    /**
     * Clear all pins value and close device connection. This method is
     * automatically called by Processing when the PApplet shuts down.
     *
     * @invisible
     */
    public void dispose() {
        try {
            //clear all
            clear();
            // Close the device

            LibUsb.close(handle);
            this.parent.exit();
            // Deinitialize the libusb context
            LibUsb.exit(null);
        } catch (Exception e) {
            System.out.println(e);
        }
    }

    /*
	 * Send the given value to the specified pin number.
	 *
	 * @param pin      the target pin number
	 * @param value    the new pin value ( 1, HIGH, 0, LOW )
	 *
	 * @see #HIGH
	 * @see #LOW
	 * @see #analogWrite( int, int )
	 *
	 * @example digitalwrite
     */
    public void digitalWrite(int pin, int value) {
        byte[] request = new byte[]{'W', 'D', (byte) pin, (byte) value, 0};

        write(handle, request);
    }

    /**
     * Retrieve the specified digital pin value.
     *
     * @param pin	the pin index
     * @return int	the pin value 0 (LOW) or 1 (HIGH), or -1 on error
     *
     * @see #digitalWrite( int, int )
     * @see #analogWrite( int, int )
     * @see #analogRead( int )
     *
     * @example digitalread
     */
    public int digitalRead(int pin) {

        byte[] request = new byte[]{'R', 'D', (byte) pin, 0};
        byte[] bytes;

        write(handle, request);

        ByteBuffer buffer = read(handle, 1);

        bytes = new byte[buffer.remaining()];

        buffer.get(bytes, 0, bytes.length);
        if (bytes[0] == 1) {
            return 1;
        } else {
            return 0;
        }
    }

    /**
     * Send the given value to the specified analog pin number.
     *
     * @param pin the target pin number
     * @param value the new pin value ( 0 - 1024 )
     *
     * @see #digitalWrite( int, int )
     * @example analogwrite
     */
    public  void analogWrite(int pin, int value) {
        int a, b, c, d;
        a = value / 1000;
        b = (value % 1000) / 100;
        c = (value % 100) / 10;
        d = (value % 10);
        if (value <= 1023) {
            byte[] request = new byte[]{'W', 'A', (byte) pin,(byte) a,(byte) b,(byte)c,(byte) d };

            write(handle, request);
        } else {
            printErr("Para analogWrite sólo estan permitidos valores entre 0 y 1023");
            dispose();

        }
    }
    /**
     * Retrieve the specified analog pin value.
     *
     * @param pin	the pin index
     * @return int	the pin value (0-1024) or -1 on error
     *
     * @see #analogWrite( int, int )
     * @see #digitalWrite( int, int )
     * @see #digitalRead( int )
     *
     * @example analogread
     */
    public int analogRead(int pin) {

        byte[] request = new byte[]{'R', 'A', (byte) pin, 0};
        byte[] data; 

        //  send the request and read the response
        write(handle, request);
       ByteBuffer buffer = read(handle, 4);
       buffer.rewind();
        data = new byte[buffer.remaining()];

        buffer.get(data, 0, data.length);
        
        int num=(((((data[0]*10)+data[1])*10)+data[2])*10)+data[3];
        return  num;
    }

    /**
     * Clear all pin values.
     */
    public void clear() {
        write(handle, new byte[]{'W', 'C', 0});
    }

    /**
     * Writes some data to the device.
     *
     * @param handle The device handle.
     * @param data The data to send to the device.
     */
    private static void write(DeviceHandle handle, byte[] data) {
        ByteBuffer buffer = BufferUtils.allocateByteBuffer(data.length);
        buffer.put(data);
        IntBuffer transferred = BufferUtils.allocateIntBuffer();
        int result = LibUsb.bulkTransfer(handle, OUT_ENDPOINT, buffer,
                transferred, TIMEOUT);
        if (result != LibUsb.SUCCESS) {
            throw new LibUsbException("Unable to send data", result);
        }
        //System.out.println(transferred.get() + " bytes sent to device");
    }

    /**
     * Reads some data from the device.
     *
     * @param handle The device handle.
     * @param size The number of bytes to read from the device.
     * @return The read data.
     */
    private static ByteBuffer read(DeviceHandle handle, int size) {

        ByteBuffer buffer = BufferUtils.allocateByteBuffer(size).order(
                ByteOrder.LITTLE_ENDIAN);
        IntBuffer transferred = BufferUtils.allocateIntBuffer();
        int result;
        result = LibUsb.bulkTransfer(handle, IN_ENDPOINT, buffer,
                transferred, TIMEOUT);

        if (result != LibUsb.SUCCESS) {
            throw new LibUsbException("Unable to read data", result);
        }

        return buffer;
    }

    public static void delay(int milisec) throws InterruptedException {
        TimeUnit.MILLISECONDS.sleep(milisec);
    }

    public static void log(boolean enable) {
        LOGGER = enable;
    }

    /**
     * Print message in console.
     *
     * @param msg the message to be printed
     */
    public static void printOut(String msg) {
        if (LOGGER) {
            System.out.println(msg);
        }
    }

    /**
     * Print error message in console.
     *
     * @param msg the message to be printed
     */
    private static void printErr(String msg) {
        if (!errmsg.equals(msg)) {
            System.err.println("!!! Pinguino error : " + msg);
            errmsg = msg;
        }
    }
    public static  void pinguinoCode(){
       
            String code="/*-----------------------------------------------------\n" +
"Author:  Yohon Bravo Castro\n" +
"Email: bravo2008@misena.edu.co\n" +
"Date: 2016-06-26\n" +
"Description: Codigo para Pinguino Processing, la cual esta basada en la libreria creada por Jean-Pierre MANDON 2009.\n" +
"\n" +
"Esta libreria es compatible con la version 1.3 de Processing y la version 4.14 del bootloader de Pinguino 2550.\n" +
"\n" +
"https://github.com/PinguinoIDE/PinguinoProcessing\n" +
"\n" +
"Version: 1.0\n" +
"\n" +
"-----------------------------------------------------*/\n" +
"\n" +
"\n" +
"u8 receivedbyte;\n" +
"char buffer[64];\n" +
"char data[8];\n" +
"int i=0,temp;\n" +
"\n" +
"\n" +
"void setup() {\n" +
"\n" +
"for( i=0; i<8; i++ ){\n" +
"	pinMode( i, OUTPUT );\n" +
"}\n" +
" clear();\n" +
"}\n" +
"void readBulk(){\n" +
" receivedbyte = BULK.read(buffer); \n" +
" buffer[receivedbyte] = 0;\n" +
"}\n" +
"void loop() {\n" +
"receivedbyte=0;\n" +
" if ( BULK.available()) {\n" +
"    readBulk();\n" +
"    if (receivedbyte > 0){ \n" +
"		if(buffer[1]=='C') clear();\n" +
"		if(buffer[0]=='W'){\n" +
"			if(buffer[1]=='D'){ \n" +
"    	   		digitalWrite(buffer[2],buffer[3]);\n" +
"			}\n" +
"			if(buffer[1]=='A'){\n" +
"			temp = (((((buffer[3] * 10) + buffer[4]) * 10) + buffer[5]) * 10) + buffer[4];\n" +
"			analogWrite(buffer[2],temp);\n" +
"			}\n" +
"		}\n" +
"		if(buffer[0]=='R'){\n" +
"			if(buffer[1]=='D'){ \n" +
"			   pinMode(buffer[2],INPUT);\n" +
"    	   		   data[0]=digitalRead(buffer[2]);\n" +
"			   BULK.write(data,1);\n" +
"			}\n" +
"			if(buffer[1]=='A'){\n" +
"			   temp=analogRead(buffer[2]);\n" +
"			   data[0]=temp/1000;\n" +
"			   data[1]=(temp%1000)/100;\n" +
"			   data[2]=(temp%100)/10;\n" +
"			   data[3]=(temp%10);\n" +
"			   BULK.write(data,4);\n" +
"				}\n" +
"			}\n" +
"    		}\n" +
"	}\n" +
"}\n" +
"void clear() {\n" +
" for( i=0; i<8; i++ ) {\n" +
"  digitalWrite( i, LOW );\n" +
" }\n" +
"}\n" +
"";
            
        System.out.println(code);
    }
    public static void info() {
        System.out.println("PinguinoB Processing Versión 1.0 \nPinguino Bootloader  Version 4.14 \nInformación de Conección a Pinguino: VID 0x04D8  PID 0xFEAA \nIN_ENDPOINT " + (byte) IN_ENDPOINT + "\nOUT_ENDPOINT " + (int) OUT_ENDPOINT);
    }

}
