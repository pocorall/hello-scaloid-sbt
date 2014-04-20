package scaloid.example

import org.scaloid.common._
import android.graphics.Color

class HelloScaloid extends SActivity {

  onCreate {
    contentView = new SVerticalLayout {
      style {
        case b: SButton => b.textColor(Color.RED).onClick(toast("Bang!"))
        case t: STextView => t textSize 10.dip
        case v => v.backgroundColor(Color.YELLOW)
      }
      STextView("I am 10 dip tall")
      STextView("Me too")
      STextView("I am taller than you") textSize 15.dip // overriding
      SEditText("Yellow input field")
      SButton(R.string.red)
    } padding 20.dip
  }

}
