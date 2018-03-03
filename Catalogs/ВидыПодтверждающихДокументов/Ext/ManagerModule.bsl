﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает массив ссылок видов документов, подтверждающих исполнение контракта согласно 275-ФЗ
//
// Возвращаемое значение:
// Массив - СправочникСсылка.ВидыПодтверждающихДокументов
//
Функция ВидыПодтверждающиеИсполнениеКонтракта() Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	ВидыПодтверждающихДокументов.Ссылка
	|ИЗ
	|	Справочник.ВидыПодтверждающихДокументов КАК ВидыПодтверждающихДокументов
	|ГДЕ
	|	ВидыПодтверждающихДокументов.ПодтверждаетИсполнениеКонтракта";
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
КонецФункции 

#КонецОбласти

#КонецЕсли

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Представление = "(" + Данные.Код + ") " + Данные.Наименование;
	
КонецПроцедуры

Процедура ОбработкаПолученияПолейПредставления(Поля, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Поля.Добавить("Код");
	Поля.Добавить("Наименование");
	
КонецПроцедуры

#КонецОбласти

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Заполняет справочник поставляемыми данными
//
Процедура ЗаполнитьПредопределенныеЭлементы() Экспорт
	
	МакетПоставляемыеДанные = Справочники.ВидыПодтверждающихДокументов.ПолучитьМакет("ПоставляемыеДанные").ПолучитьТекст();
	ТаблицаПоставляемыхДанных = ОбщегоНазначения.ПрочитатьXMLВТаблицу(МакетПоставляемыеДанные).Данные;
	
	Для Каждого СтрокаПоставляемыхДанных Из ТаблицаПоставляемыхДанных Цикл 
		ЭлементОбъект = Справочники.ВидыПодтверждающихДокументов[СтрокаПоставляемыхДанных.Имя].ПолучитьОбъект();
		
		ЗаполнитьЗначенияСвойств(ЭлементОбъект, СтрокаПоставляемыхДанных, "КраткоеНаименование, ПодтверждаетИсполнениеКонтракта");
		
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(ЭлементОбъект);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбновлениеИнформационнойБазы

#КонецОбласти

#КонецЕсли
