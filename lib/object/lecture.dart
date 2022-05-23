class Lecture {
  String classId;
  String className;
  String profName;

  Lecture(
    this.classId,
    this.className,
    this.profName,
  );
  @override
  String toString() => '$classId, $className , $profName';
}
