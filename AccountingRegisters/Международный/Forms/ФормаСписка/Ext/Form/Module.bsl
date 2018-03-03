﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	УстановитьЗаголовкиКолонок();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтборСчетПриИзменении(Элемент)
	
	ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(Список, "Счет", ОтборСчет, ЗначениеЗаполнено(ОтборСчет), ВидСравненияКомпоновкиДанных.ВИерархии);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияПриИзменении(Элемент)
	
	ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(Список, "Организация", ОтборОрганизация, ЗначениеЗаполнено(ОтборОрганизация));

КонецПроцедуры

&НаКлиенте
Процедура ОтборРегистраторПриИзменении(Элемент)
	
	ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(Список, "Регистратор", ОтборРегистратор, ЗначениеЗаполнено(ОтборРегистратор));
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если ТипЗнч(Элемент.ТекущиеДанные.Регистратор) = Тип("ДокументСсылка.ОперацияМеждународный") Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ОткрытьФорму("Документ.ОперацияМеждународный.ФормаОбъекта",
					Новый Структура("ПараметрТекущаяСтрока,Ключ", Элемент.ТекущиеДанные.НомерСтроки,Элемент.ТекущиеДанные.Регистратор));
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПереключитьАктивностьПроводок(Команда)
	
	ТекДокумент = ПолучитьДокумент();
	
	Если ТекДокумент <> Неопределено Тогда
		
		ПереключитьАктивностьПроводокСервер(ТекДокумент);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПереключитьАктивностьПроводокСервер(Документ)
	
	ПереключитьАктивностьПроводокМФУ(Документ);
	
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьДокумент()
	
	ТекДанные = Элементы.Список.ТекущиеДанные;
	
	Если ТекДанные = Неопределено Тогда
		ПоказатьПредупреждение(,НСтр("ru = 'Не выбран документ'"));
		Возврат Неопределено;
	КонецЕсли;
	
	ТекДокумент = ТекДанные.Регистратор;
	Если НЕ ЗначениеЗаполнено(ТекДокумент) Тогда
		ПоказатьПредупреждение(,НСтр("ru = 'Не выбран документ'"));
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат ТекДокумент;
	
КонецФункции

&НаСервере
Процедура ПереключитьАктивностьПроводокМФУ(Документ)
	
	Если Документ.ПометкаУдаления Тогда
		Возврат;
	КонецЕсли;

	ПроводкиДокумента = РегистрыБухгалтерии.Международный.СоздатьНаборЗаписей();
	ПроводкиДокумента.Отбор.Регистратор.Установить(Документ);
	ПроводкиДокумента.Прочитать();

	КоличествоПроводок = ПроводкиДокумента.Количество();
	Если НЕ (КоличествоПроводок = 0) Тогда
		
		// Определяем текущую активность проводок по первой проводке
		ТекущаяАктивностьПроводок = ПроводкиДокумента[0].Активность;

		// Инвертируем текущую активность проводок
		ПроводкиДокумента.УстановитьАктивность(НЕ ТекущаяАктивностьПроводок);
		ПроводкиДокумента.Записать();

	КонецЕсли;
		
КонецПроцедуры

&НаСервере
Процедура УстановитьЗаголовкиКолонок()

	Если ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций") Тогда
		Элементы.Регистратор.Заголовок = Элементы.Регистратор.Заголовок + ", " + НСтр("ru = 'Организация'");
	КонецЕсли;
	
	МеждународныйУчетОбщегоНазначения.УстановитьЗаголовкиПодразделения(Элементы.ПодразделениеДт, Элементы.ПодразделениеКт);
	
КонецПроцедуры

#КонецОбласти
