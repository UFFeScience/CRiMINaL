package ccd;

/**
 * This class represents a geographic point, determined by it's latitude 
 * name(Like a name of a shopping or a restaurant) and it's type(Restaurant, Shop...)
 * @author CCD
 */
public class GeographicPoint 
{
    private double lat;
    private double lon;
    private String name;
    private String type;
    public GeographicPoint(double lat, double lon)
    {
        this.lat = lat;
        this.lon = lon;
    }
    public double getLat()
    {
        return this.lat;
    }
    public double getLon()
    {
        return this.lon;
    }
    public void setName(String name)
    {
        this.name = name;
    }
    public void setType(String type)
    {
        this.type = type;
    }
    public String getName()
    {
        return this.name;
    }
    public String getType()
    {
        return this.type;
    }
    @Override
    public String toString() 
    {
        return "Geo Place [name=" + name + ", type=" + type + ", lat=" + lat + ", lon=" + lon + "]";
    }
}
