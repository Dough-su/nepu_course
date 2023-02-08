abstract class ILogger<T> {
  add(T note);
  remove(T note);
  clear();
  List<T> getAll();
}
