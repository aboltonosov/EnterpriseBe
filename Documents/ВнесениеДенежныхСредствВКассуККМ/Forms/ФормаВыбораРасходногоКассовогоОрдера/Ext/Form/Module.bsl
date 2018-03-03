﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	КассаККМ = Параметры.КассаККМ;
	
	ДанныеКассыККМ = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(КассаККМ, "Владелец, ВалютаДенежныхСредств");
	Организация = ДанныеКассыККМ.Владелец;
	Валюта      = ДанныеКассыККМ.ВалютаДенежныхСредств;
	
	СуммаКПоступлению = Справочники.КассыККМ.СуммаКПоступлению(КассаККМ);
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПринятьВКассу(Команда)
	
	ОчиститьСообщения();
	
	Если Не ЗначениеЗаполнено(СуммаВнесения) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Не введена сумма внесения'"),,,
			"СуммаВнесения");
		Возврат;
	КонецЕсли;
	
	Если СуммаКПоступлению < СуммаВнесения Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Сумма внесения денежных средств превышает возможную сумму поступления.'"),,,
			"СуммаВнесения");
		Возврат;
	КонецЕсли;
	
	ПринятьВКассуНаКлиенте();
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

&НаКлиенте
Процедура ПринятьВКассуНаКлиенте()
	
	СтруктураВозврата = Новый Структура;
	СтруктураВозврата.Вставить("СуммаВнесения", СуммаВнесения);
	СтруктураВозврата.Вставить("КассаККМ",      КассаККМ);
	СтруктураВозврата.Вставить("Дата",          ТекущаяДата());
	СтруктураВозврата.Вставить("Организация",   Организация);
	СтруктураВозврата.Вставить("Валюта",        Валюта);
	СтруктураВозврата.Вставить("Касса",                  Неопределено);
	СтруктураВозврата.Вставить("РасходныйКассовыйОрдер", Неопределено);
	
	Закрыть(СтруктураВозврата);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
