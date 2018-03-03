﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	ИнициализироватьОтчет();
	
	НастройкиОтчета = КомпоновщикНастроек.ПолучитьНастройки();
	
	ЗначениеПараметра = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ИспользоватьШтатноеРасписание"));
	Если ЗначениеПараметра <> Неопределено Тогда
		ЗначениеПараметра.Значение = ПолучитьФункциональнуюОпцию("ИспользоватьШтатноеРасписание");
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	
	ДокументРезультат.Очистить();
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(ЭтотОбъект.СхемаКомпоновкиДанных, НастройкиОтчета, ДанныеРасшифровки);
	
	// Создадим и инициализируем процессор компоновки.
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, , ДанныеРасшифровки, Истина);
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	
	// Обозначим начало вывода
	ПроцессорВывода.Вывести(ПроцессорКомпоновки, Истина);
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

Процедура ИнициализироватьОтчет() Экспорт
	
	ЗарплатаКадрыОбщиеНаборыДанных.ЗаполнитьОбщиеИсточникиДанныхОтчета(ЭтотОбъект);
	
КонецПроцедуры

// Для общей формы "Форма отчета" подсистемы "Варианты отчетов".
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	
	Настройки.События.ПриСозданииНаСервере = Истина;
	
КонецПроцедуры

// Вызывается в обработчике одноименного события формы отчета после выполнения кода формы.
//
// Параметры:
//   Форма - УправляемаяФорма - Форма отчета.
//   Отказ - Передается из параметров обработчика "как есть".
//   СтандартнаяОбработка - Передается из параметров обработчика "как есть".
//
// См. также:
//   "УправляемаяФорма.ПриСозданииНаСервере" в синтакс-помощнике.
//
Процедура ПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка) Экспорт
	
	ИнициализироватьОтчет();
	ЗначениеВДанныеФормы(ЭтотОбъект, Форма.Отчет);
	
КонецПроцедуры

// Функция возвращает структуру настроек отчета.
//
Функция ПолучитьНастройкиОтчета() Экспорт
	
	// Получим настройки по умолчанию.
	Настройки = ОтчетыКлиентСервер.ПолучитьНастройкиОтчетаПоУмолчанию();
	
	Возврат Настройки;
	
КонецФункции

// Формирование расшифровки отчетов статистики.
//
Процедура СформироватьОтчетРасшифровку(Параметры, ДокументРезультат) Экспорт
	СтатистикаПерсоналаРасширенный.СформироватьОтчетРасшифровку(Параметры, ДокументРезультат);
КонецПроцедуры

#КонецОбласти

#КонецЕсли