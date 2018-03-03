﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметры.Свойство("Комментарий", Комментарий);
	Параметры.Свойство("РучнаяКорректировкаПроводок", Объект.РучнаяКорректировкаПроводок);
	Параметры.Свойство("УведомлятьОПустомКомментарии", УведомлятьОПустомКомментарии);
	
	Элементы.ГруппаИспользуетсяРучнаяКорректировка.Видимость = Объект.РучнаяКорректировкаПроводок;
	Элементы.УведомлятьОКомментарии.Видимость = Объект.РучнаяКорректировкаПроводок;
	Элементы.Комментарий.ТолькоПросмотр = Не Объект.РучнаяКорректировкаПроводок;
	Элементы.Комментарий.ЦветТекста = ?(Объект.РучнаяКорректировкаПроводок, ЦветаСтиля.ЦветТекстаПоля, ЦветаСтиля.ПоясняющийОшибкуТекст);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Записать(Команда)
	Закрыть(Новый Структура("Комментарий, УведомлятьОПустомКомментарии", Комментарий, УведомлятьОПустомКомментарии));
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	Закрыть(Неопределено);
КонецПроцедуры

#КонецОбласти