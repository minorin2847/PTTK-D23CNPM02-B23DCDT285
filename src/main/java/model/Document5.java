package model;

import java.io.Serializable;

/** A document title: book, textbook, journal... (table tblDocument5). */
public class Document5 implements Serializable {
    private static final long serialVersionUID = 1L;

    private String code;
    private String type;
    private String name;
    private String author;
    private String publisher;
    private int publishedYear;
    private String genre;
    private String description;
    private byte[] image;

    public Document5() {
    }

    public String getCode() { return code; }
    public void setCode(String code) { this.code = code; }

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getAuthor() { return author; }
    public void setAuthor(String author) { this.author = author; }

    public String getPublisher() { return publisher; }
    public void setPublisher(String publisher) { this.publisher = publisher; }

    public int getPublishedYear() { return publishedYear; }
    public void setPublishedYear(int publishedYear) { this.publishedYear = publishedYear; }

    public String getGenre() { return genre; }
    public void setGenre(String genre) { this.genre = genre; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public byte[] getImage() { return image; }
    public void setImage(byte[] image) { this.image = image; }
}
