﻿// 4D:ERP для Беларуси
// {
// Форма изменена
// }
// 4D

&НаКлиенте
Перем ПараметрыОбработчикаОжидания Экспорт;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.РежимВыбора Тогда
		
		Элементы.Список.РежимВыбора = Истина;
		
		ПараметрыДляДоступныхТарифов = Справочники.ВидыТарифовСтраховыхВзносов.ПараметрыДляДоступныхТарифов(Параметры);
		ВидОрганизации = ПараметрыДляДоступныхТарифов.ВидОрганизации;
		ПрименяетсяУСН = ПараметрыДляДоступныхТарифов.ПрименяетсяУСН;
		ПрименяетсяПоОтдельнымДоходам = ПараметрыДляДоступныхТарифов.ПрименяетсяПоОтдельнымДоходам;
		Если ЗначениеЗаполнено(ВидОрганизации) ИЛИ ЗначениеЗаполнено(ПрименяетсяУСН) ИЛИ ЗначениеЗаполнено(ПрименяетсяПоОтдельнымДоходам) Тогда
			
			ДоступныеТарифыСтраховыхВзносов = УчетСтраховыхВзносов.ДоступныеТарифыСтраховыхВзносов(ВидОрганизации, ПрименяетсяУСН, ПрименяетсяПоОтдельнымДоходам);
			
			СписокДопустимыхТарифов = Новый СписокЗначений;
			СписокДопустимыхТарифов.ЗагрузитьЗначения(ДоступныеТарифыСтраховыхВзносов);
			
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
				Список.Отбор,
				"Ссылка",
				СписокДопустимыхТарифов,
				ВидСравненияКомпоновкиДанных.ВСписке);
			
		КонецЕсли;
		
	КонецЕсли;
	
	ЗарплатаКадры.ПриСозданииНаСервереФормыСДинамическимСписком(ЭтотОбъект, "Список");
	
	// 4D:ERP для Беларуси, Юлия, 18.08.2017 12:30:48 
	// Российские предопределенные элементы, № 15766
	// { 	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Наименование", "(не используется)", ВидСравненияКомпоновкиДанных.НеНачинаетсяС,,);
	// }
	// 4D
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаСервере
Процедура СписокПередЗагрузкойПользовательскихНастроекНаСервере(Элемент, Настройки)
	ЗарплатаКадры.ПроверитьПользовательскиеНастройкиДинамическогоСписка(ЭтотОбъект, Настройки);
КонецПроцедуры

&НаСервере
Процедура СписокПриОбновленииСоставаПользовательскихНастроекНаСервере(СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ЗарплатаКадры.ПроверитьПользовательскиеНастройкиДинамическогоСписка(ЭтотОбъект, , СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВосстановитьНачальныеЗначения(Команда)
	
	ЗарплатаКадрыКлиент.ВосстановитьНачальныеЗначенияСправочника(ЭтаФорма, "Справочник.ВидыТарифовСтраховыхВзносов");
	
КонецПроцедуры

#Область ПроцедурыПодсистемыНастройкиПорядкаЭлементов

&НаКлиенте
Процедура ПереместитьЭлементВверх(Команда)
	
	НастройкаПорядкаЭлементовКлиент.ПереместитьЭлементВверхВыполнить(Список, Элементы.Список);
	
КонецПроцедуры

&НаКлиенте
Процедура ПереместитьЭлементВниз(Команда)
	
	НастройкаПорядкаЭлементовКлиент.ПереместитьЭлементВнизВыполнить(Список, Элементы.Список);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура Подключаемый_ОжиданиеВыполненияДлительнойОперации()
	
	Если ЗарплатаКадрыКлиент.ВосстановлениеНачальныхЗначенийВыполнено(ЭтаФорма) Тогда
		Элементы.Список.Обновить();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
