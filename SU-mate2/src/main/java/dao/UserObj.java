package dao;

public class UserObj {
    private String id, name, ts, mbti, smoking, workout;
    
    public UserObj(String id, String name, String ts, String mbti, String smoking, String workout) {
        this.id = id;
        this.name = name;
        this.ts = ts;
        this.mbti = mbti;
        this.smoking = smoking;
        this.workout = workout;
    }

    public String getId() { return this.id; }
    public String getName() { return this.name; }
    public String getTs() { return this.ts; }
    public String getMbti() { return this.mbti; }
    public String getSmoking() { return this.smoking; }
    public String getWorkout() { return this.workout; }
}