﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Параметры.Свойство("АдресКэшаКатегорийРубрик", АдресКэшаКатегорийРубрик);
	Параметры.Свойство("ТребуетсяОбновлениеКэшаКатегории", ТребуетсяОбновлениеКэшаКатегории);
	
	Если Не ТребуетсяОбновлениеКэшаКатегории Тогда
		ИдентификаторРубрикатора = ?(Параметры.Свойство("Идентификатор"), Параметры.Идентификатор, Неопределено);
		ЗагрузитьКатегорииИзКэша(ИдентификаторРубрикатора);
	Иначе
		ЗагрузитьКатегорииСервиса(Неопределено);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыКатегории

&НаКлиенте
Процедура КатегорииВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	Если Элемент.ТекущиеДанные = Неопределено Тогда
		Закрыть();
	ИначеЕсли Элемент.ТекущиеДанные.КоличествоПодчиненных > 0 Тогда
		// Для групп разворачивание строки дерева.
		ИдентификаторСтроки = Элементы.Категории.ТекущиеДанные.Идентификатор;
		
		МассивРодителей = Новый Массив;
		ПолучитьИерархиюРодителей(Элементы.Категории.ТекущиеДанные, МассивРодителей);
		МассивРодителей.Добавить(ИдентификаторСтроки);
		
		Если Элемент.ТекущиеДанные.ПолучитьЭлементы().Количество() = 0 Тогда
			ЗагрузитьКатегорииСервиса(ИдентификаторСтроки);
		КонецЕсли;
		
		СтандартнаяОбработка = Ложь;
		
		// Разворачивание групп дерева.
		ДанныеДерева = Категории.ПолучитьЭлементы();
		Для Каждого УровеньДерева Из МассивРодителей Цикл
			Для Каждого ЭлементСтроки Из ДанныеДерева Цикл
				Если ЭлементСтроки.Идентификатор = УровеньДерева Тогда
					ДанныеДерева = ЭлементСтроки.ПолучитьЭлементы();
					Если ДанныеДерева.Количество() Тогда
						Элементы.Категории.ТекущаяСтрока = ДанныеДерева[0].ПолучитьИдентификатор();
						Прервать;
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
	Иначе
		ОбработчикВыбораИЗакрытияФормы();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьИерархиюРодителей(ТекущиеДанные, Значение)
	
	Родитель = ТекущиеДанные.ПолучитьРодителя();
	Если Родитель = Неопределено Тогда
		Возврат;
	Иначе
		Значение.Вставить(0, Родитель.Идентификатор);
		ПолучитьИерархиюРодителей(Родитель, Значение)
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОбновитьКатегории(Команда)
	
	ТребуетсяОбновлениеКэшаКатегории = Истина;
	ЗагрузитьДанныеРубрикатора();
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаВыбрать(Команда)
	
	ТекущиеДанные = Элементы.Категории.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Закрыть();
	ИначеЕсли ТекущиеДанные.КоличествоПодчиненных > 0 Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Выберите элемент, а не группу.'"));
		Возврат;
	КонецЕсли;
	
	ОбработчикВыбораИЗакрытияФормы();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбработчикВыбораИЗакрытияФормы()
	
	ПараметрыЗакрытия = Новый Структура;
	ТекущиеДанные = Элементы.Категории.ТекущиеДанные;
	ПараметрыЗакрытия.Вставить("Идентификатор", ТекущиеДанные.Идентификатор);
	ПараметрыЗакрытия.Вставить("Представление", ТекущиеДанные.Представление);
	ПараметрыЗакрытия.Вставить("АдресКэшаКатегорийРубрик", АдресКэшаКатегорийРубрик);
	Закрыть(ПараметрыЗакрытия);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьДанныеРубрикатора()
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(Неопределено);
	ПараметрыОжидания.ТекстСообщения = НСтр("ru = 'Загрузка данных рубрикатора 1С:Бизнес-сеть'");
	ПараметрыОжидания.ВыводитьПрогрессВыполнения = Ложь;
	ПараметрыОжидания.ВыводитьОкноОжидания = Истина;
	ПараметрыОжидания.ОповещениеПользователя.Показать = Ложь;
	ПараметрыОжидания.ВыводитьСообщения = Ложь;
	ПараметрыОжидания.Вставить("АдресКэшаКатегорийРубрик", АдресКэшаКатегорийРубрик);
	ДлительнаяОперация = ЗагрузитьДанныеРубрикатораВФоне(ПараметрыОжидания);
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриЗавершенииЗагрузкиРубрикатора", ЭтотОбъект);
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация,	ОписаниеОповещения, ПараметрыОжидания);
		
КонецПроцедуры

&НаКлиенте
Процедура ПриЗавершенииЗагрузкиРубрикатора(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда // Отмена длительной операции.
		Возврат;
	ИначеЕсли Результат.Статус = "Выполнено" Тогда
		АдресКэшаКатегорийРубрик = Результат.АдресРезультата;
		ЗагрузитьКатегорииИзКэша(Неопределено);
		ТребуетсяОбновлениеКэшаКатегории = Ложь;
	Иначе
		АдресКэшаКатегорийРубрик = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьКатегорииИзКэша(ИдентификаторРубрикатора)
	
	Если ЗначениеЗаполнено(АдресКэшаКатегорийРубрик) Тогда
		Дерево = ПолучитьИзВременногоХранилища(АдресКэшаКатегорийРубрик);
		Если ТипЗнч(Дерево) = Тип("ДеревоЗначений") Тогда
			ЗначениеВРеквизитФормы(Дерево, "Категории");
		КонецЕсли;
		Если ЗначениеЗаполнено(ИдентификаторРубрикатора) Тогда
			
			ИдентификаторСтроки = СтрокаПоИдентификатору(Категории, ИдентификаторРубрикатора);
			Если ЗначениеЗаполнено(ИдентификаторСтроки) Тогда
				Элементы.Категории.ТекущаяСтрока = ИдентификаторСтроки;
			КонецЕсли; 
		КонецЕсли;
	КонецЕсли;
	Элементы.ГруппаСтраниц.ТекущаяСтраница = Элементы.СтраницаКатегории;
	Элементы.КомандаВыбрать.Доступность = Истина;
	
КонецПроцедуры

&НаСервере
Функция СтрокаПоИдентификатору(Категория, ИдентификаторРубрикатора)
	
	СписокЭлементов = Категория.ПолучитьЭлементы();
	Для каждого ЭлементСписка Из СписокЭлементов Цикл
		Если ЭлементСписка.Идентификатор = ИдентификаторРубрикатора Тогда
			Возврат ЭлементСписка.ПолучитьИдентификатор();
		Иначе
			Результат = СтрокаПоИдентификатору(ЭлементСписка, ИдентификаторРубрикатора);
			Если ЗначениеЗаполнено(Результат) Тогда
				Возврат Результат;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Неопределено;
	
КонецФункции
	
&НаСервере
Функция ЗагрузитьДанныеРубрикатораВФоне(ПараметрыОжидания)
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Загрузка рубрикатора 1С:Бизнес-сеть'");
	ПараметрыВыполнения.АдресРезультата = АдресКэшаКатегорийРубрик;
	
	Возврат ДлительныеОперации.ВыполнитьВФоне("Обработки.ТорговыеПредложения.ПолучитьКатегорииПервогоУровня",
		ПараметрыОжидания, ПараметрыВыполнения);
	
КонецФункции

&НаСервере
Процедура ЗагрузитьКатегорииСервиса(Знач Идентификатор)
	
	ДеревоКатегорий = РеквизитФормыВЗначение("Категории");
	Если Идентификатор = Неопределено Тогда
		СтрокаДерева = ДеревоКатегорий;
	Иначе
		СтрокаДерева = ДеревоКатегорий.Строки.Найти(Идентификатор, "Идентификатор", Истина);
	КонецЕсли;

	// Заполнение данных из сервиса.
	ТорговыеПредложения.ПолучитьКатегорииРубрикатора(СтрокаДерева, Идентификатор);
	
	ЗначениеВРеквизитФормы(ДеревоКатегорий, "Категории");
	ПоместитьВоВременноеХранилище(ДеревоКатегорий, АдресКэшаКатегорийРубрик)
	
КонецПроцедуры

#КонецОбласти

