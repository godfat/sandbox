=begin
** Form generated from reading ui file 'untitled.ui'
**
** Created: Mon Jun 2 15:35:33 2008
**      by: Qt User Interface Compiler version 4.3.4
**
** WARNING! All changes made in this file will be lost when recompiling ui file!
=end

require 'Qt4'

class Ui_Dialog
    attr_reader :buttonBox
    attr_reader :radioButton
    attr_reader :radioButton_2

    def setupUi(dialog)
    if dialog.objectName.nil?
        dialog.objectName = "dialog"
    end
    dialog.resize(400, 300)
    @buttonBox = Qt::DialogButtonBox.new(dialog)
    @buttonBox.objectName = "buttonBox"
    @buttonBox.geometry = Qt::Rect.new(30, 240, 341, 32)
    @buttonBox.orientation = Qt::Horizontal
    @buttonBox.standardButtons = Qt::DialogButtonBox::Cancel|Qt::DialogButtonBox::NoButton|Qt::DialogButtonBox::Ok
    @radioButton = Qt::RadioButton.new(dialog)
    @radioButton.objectName = "radioButton"
    @radioButton.geometry = Qt::Rect.new(200, 80, 100, 21)
    @radioButton_2 = Qt::RadioButton.new(dialog)
    @radioButton_2.objectName = "radioButton_2"
    @radioButton_2.geometry = Qt::Rect.new(60, 140, 100, 21)

    retranslateUi(dialog)
    Qt::Object.connect(@buttonBox, SIGNAL('accepted()'), dialog, SLOT('accept()'))
    Qt::Object.connect(@buttonBox, SIGNAL('rejected()'), dialog, SLOT('reject()'))

    Qt::MetaObject.connectSlotsByName(dialog)
    end # setupUi

    def setup_ui(dialog)
        setupUi(dialog)
    end

    def retranslateUi(dialog)
    dialog.windowTitle = Qt::Application.translate("Dialog", "Dialog", nil, Qt::Application::UnicodeUTF8)
    @radioButton.text = Qt::Application.translate("Dialog", "RadioButton", nil, Qt::Application::UnicodeUTF8)
    @radioButton_2.text = Qt::Application.translate("Dialog", "RadioButton", nil, Qt::Application::UnicodeUTF8)
    end # retranslateUi

    def retranslate_ui(dialog)
        retranslateUi(dialog)
    end

end

module Ui
    class Dialog < Ui_Dialog
    end
end  # module Ui

if $0 == __FILE__
    a = Qt::Application.new(ARGV)
    u = Ui_Dialog.new
    w = Qt::Dialog.new
    u.setupUi(w)
    w.show
    a.exec
end
