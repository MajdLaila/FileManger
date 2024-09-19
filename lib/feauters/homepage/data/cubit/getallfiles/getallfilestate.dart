sealed class Getallfilestate {}

final class Getallfilestateinit extends Getallfilestate {}

final class Getallfilestateloading extends Getallfilestate {}

final class Getallfilestatesuccss extends Getallfilestate {
  final Map<String, List<String>> fileSystem;
  Getallfilestatesuccss({required this.fileSystem});
}

final class Getallfilestatefailuer extends Getallfilestate {
  final String error;

  Getallfilestatefailuer({required this.error});
}
