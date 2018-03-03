﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ПартнерыИКонтрагентыВызовСервера.ДанныеАвторизовавшегосяВнешнегоПользователя());
		
	Если Партнер = Неопределено ИЛИ Партнер.Пустая() Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	СамообслуживаниеСервер.ФормаСпискаПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	СамообслуживаниеСервер.ЗаполнитьСписокВыбораКонтактныхЛиц(Элементы.КонтактноеЛицоОтбор.СписокВыбора, Партнер, КонтактноеЛицо);
	Список.Параметры.УстановитьЗначениеПараметра("Партнер",Партнер);
	
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма, Элементы.ПодменюПечать);
	// Конец СтандартныеПодсистемы.Печать
	

	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "Список.Дата", Элементы.Дата.Имя);


КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	КонтактноеЛицоОтбор  = Настройки.Получить("КонтактноеЛицоОтбор");
	СамообслуживаниеКлиентСервер.УстановитьОтборСпискаПоКонтактномуЛицу(ЭтотОбъект);
	
КонецПроцедуры


#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КонтактноеЛицоОтборПриИзменении(Элемент)
	
	СамообслуживаниеКлиентСервер.УстановитьОтборСпискаПоКонтактномуЛицу(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Если Копирование Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Печать

#КонецОбласти

#Область СлужебныеПроцедурыИФункции


#КонецОбласти
