﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ 

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		
		Если ДанныеЗаполнения.Свойство("Партнер") И ЗначениеЗаполнено(ДанныеЗаполнения.Партнер) Тогда
			Запрос = Новый Запрос(
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	Партнеры.Наименование,
			|	Партнеры.НаименованиеПолное,
			|	ВЫБОР
			|		КОГДА Партнеры.ЮрФизЛицо = ЗНАЧЕНИЕ(Перечисление.КомпанияЧастноеЛицо.ЧастноеЛицо)
			|			ТОГДА ИСТИНА
			|		ИНАЧЕ ЛОЖЬ
			|	КОНЕЦ КАК ЭтоФизЛицо
			|ИЗ
			|	Справочник.Партнеры КАК Партнеры
			|ГДЕ
			|	Партнеры.Ссылка = &Партнер");
			Запрос.УстановитьПараметр("Партнер", ДанныеЗаполнения.Партнер);
			Результат = Запрос.Выполнить();
			Если Результат.Пустой() Тогда
				Возврат;
			КонецЕсли;
			ПартнерВладелец = Результат.Выбрать();
			ПартнерВладелец.Следующий();
			Партнер = ДанныеЗаполнения.Партнер;
			Наименование = ПартнерВладелец.Наименование;
			НаименованиеПолное = ПартнерВладелец.НаименованиеПолное;
			Если ПартнерВладелец.ЭтоФизЛицо ИЛИ Партнер = Справочники.Партнеры.РозничныйПокупатель Тогда
				ЮрФизЛицо = Перечисления.ЮрФизЛицо.ФизЛицо;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ПартнерыИКонтрагенты.ПроверитьКорректностьЗаполненияКонтрагента(ЭтотОбъект, Ссылка, Отказ);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	Если ЮрФизЛицо = Перечисления.ЮрФизЛицо.ИндивидуальныйПредприниматель
		Или ЮрФизЛицо = Перечисления.ЮрФизЛицо.ФизЛицо Тогда
		
		ЮридическоеФизическоеЛицо = Перечисления.ЮридическоеФизическоеЛицо.ФизическоеЛицо;
		
	ИначеЕсли ЮрФизЛицо = Перечисления.ЮрФизЛицо.ЮрЛицо
		Или ЮрФизЛицо = Перечисления.ЮрФизЛицо.ЮрЛицоНеРезидент Тогда
		
		ЮридическоеФизическоеЛицо = Перечисления.ЮридическоеФизическоеЛицо.ЮридическоеЛицо;
		
	КонецЕсли;
	
	ПоставщикИРезидент = Не Партнер.Пустая()
		И (ЮрФизЛицо <> Перечисления.ЮрФизЛицо.ЮрЛицоНеРезидент)
		И (ЮрФизЛицо <> Перечисления.ЮрФизЛицо.ФизЛицо)
		И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Партнер, "Поставщик") = Истина;
	
	Если Не ПоставщикИРезидент Тогда
		НДСпоСтавкам4и2 = Ложь;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ГоловнойКонтрагент) И Не ОбособленноеПодразделение Тогда
		
		Если ЭтоНовый() Тогда
			НоваяСсылка = Справочники.Контрагенты.ПолучитьСсылку();
			УстановитьСсылкуНового(НоваяСсылка);
			ГоловнойКонтрагент = ПолучитьСсылкуНового();
		Иначе
			ГоловнойКонтрагент = Ссылка;
		КонецЕсли;
		
	КонецЕсли;
	
	// Обработка смены пометки удаления.
	Если Не ЭтоНовый() И Не ЭтоГруппа Тогда

		Если ПометкаУдаления <> ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "ПометкаУдаления") Тогда
			Справочники.КлючиАналитикиУчетаПоПартнерам.УстановитьПометкуУдаления(Новый Структура("Контрагент", Ссылка), ПометкаУдаления);
			Справочники.КлючиАналитикиУчетаПартий.УстановитьПометкуУдаления(Новый Структура("Контрагент", Ссылка), ПометкаУдаления);
		КонецЕсли;
		
		//изменим ИНН в подчиненных контрагентах
		Если Не ОбособленноеПодразделение И ЮрФизЛицо = Перечисления.ЮрФизЛицо.ЮрЛицо Тогда
			ПартнерыИКонтрагенты.ИзменитьИННПодчиненныхКонтрагентов(Ссылка, ИНН);
		КонецЕсли;
	
	КонецЕсли;

КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Если ОбъектКопирования.ГоловнойКонтрагент = ОбъектКопирования.Ссылка Тогда
		ГоловнойКонтрагент = Справочники.Контрагенты.ПустаяСсылка();
	КонецЕсли;
	
КонецПроцедуры

#КонецЕсли


