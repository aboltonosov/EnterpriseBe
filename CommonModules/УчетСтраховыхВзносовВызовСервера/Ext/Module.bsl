﻿
#Область СлужебныеПроцедурыИФункции

// Обработчик события "ОбработкаПолученияДанныхВыбора" модуля менеджера справочника ВидыДоходовПоСтраховымВзносам.
//
// Параметры:
//  	ДанныеВыбора			- СписокЗначений
//		Параметры				- Структура
//		СтандартнаяОбработка	- Булево
//
Процедура ВидыДоходовПоСтраховымВзносамОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка) Экспорт
	
	Если НЕ Параметры.Отбор.Свойство("Ссылка") 
		ИЛИ ТипЗнч(Параметры.Отбор.Ссылка) = Тип("ФиксированныйМассив") Тогда
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("НеДоступныеЭлементы", Справочники.ВидыДоходовПоСтраховымВзносам.НеДоступныеЭлементыПоЗначениямФункциональныхОпций());
		
		Запрос.Текст =
			"ВЫБРАТЬ
			|	ВидыДоходовПоСтраховымВзносам.Ссылка
			|ИЗ
			|	Справочник.ВидыДоходовПоСтраховымВзносам КАК ВидыДоходовПоСтраховымВзносам
			|ГДЕ
			|	НЕ ВидыДоходовПоСтраховымВзносам.Ссылка В (&НеДоступныеЭлементы)
			|	И ВидыДоходовПоСтраховымВзносам.Ссылка В(&СсылкиОтбора)";
			
		Если Параметры.Отбор.Свойство("Ссылка") Тогда
			Запрос.УстановитьПараметр("СсылкиОтбора", Параметры.Отбор.Ссылка);
		Иначе
			Запрос.Текст = СтрЗаменить(Запрос.Текст, "И ВидыДоходовПоСтраховымВзносам.Ссылка В(&СсылкиОтбора)", "");
		КонецЕсли;
		
		МассивДоступныхЭлементов = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
		Параметры.Отбор.Вставить("Ссылка", Новый ФиксированныйМассив(МассивДоступныхЭлементов));
		
	КонецЕсли; 
	
	ЗарплатаКадрыВызовСервера.ПодготовитьДанныеВыбораКлассификаторовСПорядкомРеквизитаДопУпорядочивания(ДанныеВыбора, Параметры, СтандартнаяОбработка, "Справочник.ВидыДоходовПоСтраховымВзносам");
	
КонецПроцедуры

// Обработчик события "ОбработкаПолученияДанныхВыбора" модуля менеджера справочника ВидыТарифовСтраховыхВзносов.
//
// Параметры:
//  	ДанныеВыбора			- СписокЗначений
//		Параметры				- Структура
//		СтандартнаяОбработка	- Булево
//
Процедура ВидыТарифовСтраховыхВзносовОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	Запрос = Новый Запрос;
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВидыТарифовСтраховыхВзносов.Ссылка
	|ИЗ
	|	Справочник.ВидыТарифовСтраховыхВзносов КАК ВидыТарифовСтраховыхВзносов
	|ГДЕ &УсловиеЗапроса
	|
	|УПОРЯДОЧИТЬ ПО
	|	ВидыТарифовСтраховыхВзносов.РеквизитДопУпорядочивания";
	
	УсловиеЗапроса = "";

	ПараметрыДляДоступныхТарифов = Справочники.ВидыТарифовСтраховыхВзносов.ПараметрыДляДоступныхТарифов(Параметры);
	ВидОрганизации = ПараметрыДляДоступныхТарифов.ВидОрганизации;
	ПрименяетсяУСН = ПараметрыДляДоступныхТарифов.ПрименяетсяУСН;
	ПрименяетсяПоОтдельнымДоходам = ПараметрыДляДоступныхТарифов.ПрименяетсяПоОтдельнымДоходам;
	
	Если ЗначениеЗаполнено(ВидОрганизации) ИЛИ ЗначениеЗаполнено(ПрименяетсяУСН) ИЛИ ЗначениеЗаполнено(ПрименяетсяПоОтдельнымДоходам) Тогда
	
		ДоступныеТарифыСтраховыхВзносов = УчетСтраховыхВзносов.ДоступныеТарифыСтраховыхВзносов(ВидОрганизации, ПрименяетсяУСН, ПрименяетсяПоОтдельнымДоходам);
		
		Запрос.УстановитьПараметр("ДоступныеТарифыСтраховыхВзносов", ДоступныеТарифыСтраховыхВзносов);
		
		УсловиеЗапроса = "ГДЕ
						  |	ВидыТарифовСтраховыхВзносов.Ссылка В (&ДоступныеТарифыСтраховыхВзносов)";
	
	КонецЕсли;
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "ГДЕ &УсловиеЗапроса", УсловиеЗапроса);
	Выборка = Запрос.Выполнить().Выбрать();
	
	ДанныеВыбора = Новый СписокЗначений;
	Пока Выборка.Следующий() Цикл
		ДанныеВыбора.Добавить(Выборка.Ссылка);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
