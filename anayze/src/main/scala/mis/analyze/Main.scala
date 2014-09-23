package mis.analyze

import java.io.{File, FileFilter}
import java.text.SimpleDateFormat
import java.util.Date

object Main {
  val resultDirFileName: String = "D:\\Projects\\MIS\\models\\mis-lib-performance\\results\\module2-module1"
  val resultGroups: List[String] = List("current", "rsl", "custom")

  case class Result(name: String, time: Date, millis: Double, memory: Double)

  def parseDate(dateString: String): Date = {
    val format: SimpleDateFormat = new SimpleDateFormat("YYYY-MM-dd HH:mm:ss.SSS")
    val date: Date = format.parse(dateString.substring(0, dateString.length - 3))
    date
  }

  def parseResult(l: String): Result = {
    val sI: Int = l.indexOf("|")
    val eI: Int = l.indexOf("|", sI + 1)
    val name = l.substring(sI + 1, eI)
    val dateString = l.substring(eI + 1)
    Result(name, parseDate(dateString), 0L, 0L)
  }

  def parseResult(f: File): Array[Result] = {
    val lines: Array[String] = scala.io.Source.fromFile(f).getLines().toArray
    val results: Array[Result] = lines.filter(l => l.contains("|")).map(parseResult)
    val firstResult = parseResult(lines(0))
    results.map(r => Result(r.name, r.time, r.time.getTime - firstResult.time.getTime, 0L))
  }

  def parseMemResults(parent: File): Array[Result] = {
    parent.getParentFile.listFiles(new FileFilter {
      override def accept(pathname: File): Boolean = {
        val name: String = pathname.getName
        name.startsWith("mem") && name.endsWith(parent.getName)
      }
    }).map(memFile => {
      val name: String = memFile.getName
      val sI: Int = name.indexOf("_")
      val eI: Int = name.indexOf("_", sI + 1)
      val stateName: String = name.substring(sI + 1, eI)
      val lines: Array[String] = scala.io.Source.fromFile(memFile).getLines().toArray
      Result(stateName, null, 0, lines(0).toLong)
    })
  }

  def mergeResult(results: Array[Result], memResults: Array[Result]): Array[Result] = {
    val stateNames: Set[String] = results.map(r => r.name).toSet
    stateNames.toArray.map(stateName => {
      val stateResults: Array[Result] = results.filter(r => r.name.equals(stateName))
      val avResult1: Result = stateResults.foldLeft(stateResults(0))((avResult, r) =>
        Result(stateName, new Date((avResult.time.getTime + r.time.getTime) / 2), avResult.millis / 2.0 + r.millis / 2.0, 0))


      val memStateResults: Array[Result] = memResults.filter(r => r.name.equals(stateName))
      if (memStateResults.isEmpty)
        avResult1
      else {
        val avResult2: Result = memStateResults.foldLeft(memStateResults(0))((r1, r2) => Result(r1.name, r1.time, r1.millis, (r1.memory + r2.memory) / 2))
        Result(avResult1.name, avResult1.time, avResult1.millis, avResult2.memory)
      }
    })
  }

  def createMapResult(prefixName: String): Map[String, Array[Result]] = {
    new File(resultDirFileName).listFiles(new FileFilter {
      override def accept(pathname: File): Boolean = {
        pathname.getName.startsWith(prefixName)
      }
    }).map(f => {
      val results = parseResult(f)
      val memResults = parseMemResults(f)
      val result: Array[Result] = mergeResult(results, memResults)
      f.getName -> result
    }).foldLeft(Map.empty[String, Array[Result]])((m, i) => m + i)
  }

  def createDiffResult(results: Array[Result], results1: Array[Result]): Array[Main.Result] = {
    results.map(r => {
      val otherResult: Option[Result] = results1.find(r1 => r.name.equalsIgnoreCase(r1.name))
      val result: Result = otherResult.get
      Result(r.name, r.time, r.millis - result.millis, r.memory - result.memory)
    })
  }

  def main(args: Array[String]) {
    val mapResultGroups = resultGroups.foldLeft(Map.empty[String, Array[Result]])((m, i) => m + (i -> createAverageResult(createMapResult(i))))
    val mainResultGroupName: String = resultGroups(0)
    val mainAverageResult = mapResultGroups.getOrElse(mainResultGroupName, null)

    val stateWidth = 25
    val colWidth = 15

    for (groupName <- mapResultGroups.keys) {
      if (!groupName.equals(mainResultGroupName)) {
        println()
        println()
        println("difference between " + mainResultGroupName + " and " + groupName)
        printHeader(stateWidth, colWidth)
        val otherGroupResults: Array[Result] = mapResultGroups.getOrElse(groupName, null)
        val diffResult: Array[Result] = createDiffResult(mainAverageResult, otherGroupResults)
        diffResult.sortBy(r => r.time)
          .foreach(r => {
          val oR: Result = mainAverageResult.find(i => i.name.equalsIgnoreCase(r.name)).get
          val rR: Result = otherGroupResults.find(i => i.name.equalsIgnoreCase(r.name)).get
          val formattedName: String = fillWithSpaces(r.name, stateWidth)
          val oRMillisFormatted: String = fillWithSpaces(oR.millis.toString, colWidth)
          val rRMillisFormatted: String = fillWithSpaces(rR.millis.toString, colWidth)
          val rMillisFormatted: String = fillWithSpaces(r.millis.toString, colWidth)
          val oRMemoryFormatted: String = fillWithSpaces(oR.memory.toString, colWidth)
          val rRMemoryFormatted: String = fillWithSpaces(rR.memory.toString, colWidth)
          val rMemoryFormatted: String = fillWithSpaces(r.memory.toString, colWidth)
          println(formattedName + "\t|\t" + oRMillisFormatted + "\t|\t" + rRMillisFormatted + "\t|\t" + rMillisFormatted
            + "\t|\t" + oRMemoryFormatted + "\t|\t" + rRMemoryFormatted + "\t|\t" + rMemoryFormatted)
        })
      }
    }
  }

  def printHeader(stateWidth: Int, colWidth: Int) {
    val header: String = fillWithSpaces("STATE_NAME", stateWidth) + "\t|\t" +
      fillWithSpaces("MILLIS, t1", colWidth) + "\t|\t" +
      fillWithSpaces("MILLIS, t2", colWidth) + "\t|\t" +
      fillWithSpaces("MILLIS, t1 - t2", colWidth) + "\t|\t" +
      fillWithSpaces("MEMORY, m1", colWidth) + "\t|\t" +
      fillWithSpaces("MEMORY, m2", colWidth) + "\t|\t" +
      fillWithSpaces("MEMORY, m1 - m2", colWidth)
    println(header)
    for (i <- 1 to (header.length + 2 * 7))
      print("-")
    println()
  }

  def fillWithSpaces(str: String, length: Int): String = {
    String.format("%1$" + length + "s", str)
  }

  def createAverageResult(results: Map[String, Array[Result]]): Array[Result] = {
    val items: Array[Result] = results.values.fold(Array.empty)((r1, r2) => r1 ++ r2)
    val stateNames: Set[String] = items.map(r => r.name).toSet

    stateNames.toArray.map(stateName => {
      val stateResults: Array[Result] = items.filter(r => r.name.equals(stateName))
      stateResults.foldLeft(stateResults(0))((avResult, r) =>
        Result(stateName, new Date((avResult.time.getTime + r.time.getTime) / 2), (avResult.millis + r.millis) / 2.0, (avResult.memory + r.memory) / 2.0))
    })
  }
}
