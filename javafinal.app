import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import java.io.*;
import java.util.*;

// Diğer sınıflar aynı

class JsonUtils {
    private static final Gson gson = new Gson();

    public static <T> void writeToJsonFile(String fileName, List<T> data) {
        try (Writer writer = new FileWriter(fileName)) {
            gson.toJson(data, writer);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public static <T> List<T> readFromJsonFile(String fileName, Class<T> clazz) {
        try (Reader reader = new FileReader(fileName)) {
            return gson.fromJson(reader, TypeToken.getParameterized(List.class, clazz).getType());
        } catch (FileNotFoundException e) {
            return new ArrayList<>();
        } catch (IOException e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
}

// SinemaSistemi sınıfına eklemeler

class SinemaSistemi {
    private static final String MUSTERI_FILE = "Musteri.json";
    private static final String FILM_FILE = "Film.json";
    private static final String SALON_FILE = "Salon.json";

    private List<Musteri> musteriler;
    private List<Film> filmler;
    private List<Salon> salonlar;

    public SinemaSistemi() {
        this.musteriler = JsonUtils.readFromJsonFile(MUSTERI_FILE, Musteri.class);
        this.filmler = JsonUtils.readFromJsonFile(FILM_FILE, Film.class);
        this.salonlar = JsonUtils.readFromJsonFile(SALON_FILE, Salon.class);
    }

    public void yeniMusteriEkle(Musteri musteri, int salonIndex) {
        musteriler.add(musteri);
        JsonUtils.writeToJsonFile(MUSTERI_FILE, musteriler);
        salonlar.get(salonIndex).musteriEkle(musteri);
        JsonUtils.writeToJsonFile(SALON_FILE, salonlar);
        System.out.println("Yeni müşteri eklendi: " + musteri.getName() + ", Salon: " + salonlar.get(salonIndex).getName() + ", Film: " + salonlar.get(salonIndex).getFilm().getAd());
    }

    public void yeniFilmEkle(Film film) {
        filmler.add(film);
        JsonUtils.writeToJsonFile(FILM_FILE, filmler);
        System.out.println("Yeni film eklendi: " + film.getAd());
    }

    public void yeniSalonEkle(Salon salon) {
        salonlar.add(salon);
        JsonUtils.writeToJsonFile(SALON_FILE, salonlar);
        System.out.println("Yeni salon eklendi: " + salon.getName());
    }

    public void filmVeSalonlariListele() {
        System.out.println("=== Filmler ve Salonlar ===");
        for (Film film : filmler) {
            film.bilgiGoster();
            System.out.println("Gösterildiği Salonlar:");
            for (Salon salon : salonlar) {
                if (salon.getFilm().equals(film)) {
                    System.out.println("   - Salon: " + salon.getName() + " (Salon ID: " + salon.getId() + ")");
                }
            }
            System.out.println();
        }
    }

    public void salonMusterileriniListele(int salonId) {
        for (Salon salon : salonlar) {
            if (salon.getId() == salonId) {
                salon.bilgiGoster();
                return;
            }
        }
        System.out.println("Salon bulunamadı.");
    }

    public List<Film> getFilmler() {
        return filmler;
    }

    public List<Salon> getSalonlar() {
        return salonlar;
    }
}

// Main sınıfı aynı kalabilir
