package ccd;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.util.LinkedList;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

/**
 *
 * @author CCD
 */
public class CCD 
{
    static NodeList nList;
    static NodeList wList;
    public static void main(String[] args) 
    {
        String path = System.getProperty("user.dir");
        String fileName = "niteroi_info.osm";
        init(path + File.separator + fileName);
    }
    public static void init(String inputFile) 
    {
        try 
        {
            String outputFile = "geo_places.csv";
            System.out.println(inputFile);
            DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
            DocumentBuilder db = dbf.newDocumentBuilder();
            Document doc = db.parse(new File(inputFile));
            nList = doc.getElementsByTagName("node");
            BufferedWriter out = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(outputFile, false), "UTF-16"));
            importNodeCoordinates(out);
        } 
        catch (FileNotFoundException e) 
        {
            System.out.println("File not found. Maybe the .osm file is not in the project directory or it does not have the \"niteroi_info.osm\" name");
        }
        catch (Exception e) 
        {
            System.out.println("Error:" + e);
        }
    }

    public static void importNodeCoordinates(BufferedWriter out) throws IOException 
    {
        LinkedList<GeographicPoint> geoList = new LinkedList<GeographicPoint>();
        generateHeader(out);
        for (int i = 0; i < nList.getLength(); i++) 
        {
            Node n = nList.item(i);
            Node childNode = n.getFirstChild();
            Element element = (Element) n;
            String name = null;
            String type = null;
            double lat = 0;
            double lon = 0;
            lat = Double.valueOf(element.getAttribute("lat"));
            lon = Double.valueOf(element.getAttribute("lon"));
            boolean hasExpectedTag = false;
            while(childNode != null && childNode.getNextSibling() != null)
            {
                if(childNode.getNodeType() == Node.ELEMENT_NODE && "tag".equals(childNode.getNodeName()))
                {
                    Element e = (Element) childNode;
                    String k = e.getAttribute("k");
                    if(k.equals("name"))
                        name = e.getAttribute("v");
                    else if(k.equals("shop"))
                    {
                        if(e.getAttribute("v").equals("electronics"))
                            type = "loja_de_eletronicos";
                        else if(e.getAttribute("v").equals("supermarket"))
                            type = "super_mercado";
                        else if(e.getAttribute("v").equals("kiosk"))
                            type = "quiosque";
                    }
                    else if(k.equals("amenity"))
                    {
                        if(e.getAttribute("v").equals("bank"))
                            type = "banco";
                        else if(e.getAttribute("v").equals("restaurant"))
                            type = "restaurante";
                        else if(e.getAttribute("v").equals("university"))
                            type = "universidade";
                        else if(e.getAttribute("v").equals("school"))
                            type = "escola";
                        else if(e.getAttribute("v").equals("clinic"))
                            type = "clinica";
                        else if(e.getAttribute("v").equals("pub"))
                            type = "bar";
                        else if(e.getAttribute("v").equals("theatre"))
                            type = "teatro";
                        else if(e.getAttribute("v").equals("fuel"))
                            type = "posto_de_gasolina";
                        else if(e.getAttribute("v").equals("hospital"))
                            type = "hospital";
                        else if(e.getAttribute("v").equals("bar"))
                            type = "bar";
                        // We can get bus_station,bus_stop and fast_food here.
                    }
                    else if(k.equals("pharmacy") && e.getAttribute("v").equals("pharmacy"))
                        type = "farmacia";
                    else if(k.equals("tourism"))
                        type = "ponto_turistico";
                }
                childNode = childNode.getNextSibling();
            }
            hasExpectedTag = type != null;
            if(hasExpectedTag)
            {
                GeographicPoint actualGeoPoint = new GeographicPoint(lat, lon);
                actualGeoPoint.setName(name);
                actualGeoPoint.setType(type);
                geoList.add(actualGeoPoint);
                System.out.println(actualGeoPoint);
                writeCSVLine(out, actualGeoPoint);
            }
        }
        out.flush();
        out.close();
    }
    public static void generateHeader(BufferedWriter out) throws IOException
    {
        out.append("latitude");
        out.append(',');
        out.append("longitude");
        out.append(',');
        out.append("place");
        out.append(',');
        out.append("name");
        out.append(',');
        out.append("type");
        out.append('\n');
    }
    public static void writeCSVLine(BufferedWriter out, GeographicPoint gPoint) throws IOException
    {
        out.append(String.valueOf(gPoint.getLat()));
        out.append(',');
        out.append(String.valueOf(gPoint.getLon()));
        out.append(',');
        out.append("Niteroi");
        out.append(',');
        if(gPoint.getName() != null)
           out.append(gPoint.getName());
        else
           out.append("NULL");
        out.append(',');
        out.append(gPoint.getType());
        out.append('\n');   
    }
}
