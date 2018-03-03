﻿&НаКлиенте
Перем КэшированныеЗначения;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Запись, ЭтотОбъект);

	ПриЧтенииСозданииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ТекущийОбъект.Подразделение = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ТекущийОбъект.МаршрутнаяКарта, "Подразделение");
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	УправлениеДаннымиОбИзделияхКлиент.ОповеститьОЗаписиОсновнойМаршрутнойКарты(Запись);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура МаршрутнаяКартаПриИзменении(Элемент)
	
	ПриИзмененииМаршрутнойКарты(Истина, КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура НоменклатураПриИзменении(Элемент)
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПроверитьХарактеристикуПоВладельцу", Запись.Характеристика);

	СтруктураСтроки = Новый Структура;
	СтруктураСтроки.Вставить("Номенклатура",   Запись.Номенклатура);
	СтруктураСтроки.Вставить("Характеристика", Запись.Характеристика);
	СтруктураСтроки.Вставить("ХарактеристикиИспользуются", ХарактеристикиИспользуются);
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(СтруктураСтроки, СтруктураДействий, КэшированныеЗначения);

	ЗаполнитьЗначенияСвойств(Запись, СтруктураСтроки);
	
	ХарактеристикиИспользуются = СтруктураСтроки.ХарактеристикиИспользуются;
	Элементы.Характеристика.Доступность = ХарактеристикиИспользуются;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()

	ПриИзмененииМаршрутнойКарты(Запись.ИсходныйКлючЗаписи.Пустой(), Неопределено);
	
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииМаршрутнойКарты(ЗаполнитьПоля, КэшированныеЗначения)

	Элементы.Номенклатура.СписокВыбора.Очистить();
	
	Если Запись.МаршрутнаяКарта.Пустая() Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ВыходныеИзделия.Номенклатура,
	               |	ВыходныеИзделия.Характеристика
	               |ИЗ
	               |	Справочник.МаршрутныеКарты.ВыходныеИзделия КАК ВыходныеИзделия
	               |ГДЕ
	               |	ВыходныеИзделия.Ссылка = &Объект
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	ВыходныеИзделия.НомерСтроки";
	
	Запрос.УстановитьПараметр("Объект", Запись.МаршрутнаяКарта);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	// Ограничим выбор изделий списком изделий маршрутной карты
	Пока Выборка.Следующий() Цикл
		Элементы.Номенклатура.СписокВыбора.Добавить(Выборка.Номенклатура);
	КонецЦикла;
	
	// Если это новая запись, то попробуем автоматически заполнить поля Номенклатура и Характеристика
	Если ЗаполнитьПоля Тогда
		Если Элементы.Номенклатура.СписокВыбора.Количество() = 1 Тогда
			Выборка.Сбросить();
			Выборка.Следующий();
			Запись.Номенклатура   = Выборка.Номенклатура;
			Запись.Характеристика = Выборка.Характеристика;
		КонецЕсли; 
	КонецЕсли; 
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПроверитьХарактеристикуПоВладельцу", Запись.Характеристика);

	СтруктураСтроки = Новый Структура;
	СтруктураСтроки.Вставить("Номенклатура",   Запись.Номенклатура);
	СтруктураСтроки.Вставить("Характеристика", Запись.Характеристика);
	СтруктураСтроки.Вставить("ХарактеристикиИспользуются", ХарактеристикиИспользуются);
	
	ОбработкаТабличнойЧастиСервер.ОбработатьСтрокуТЧ(СтруктураСтроки, СтруктураДействий, КэшированныеЗначения);

	ЗаполнитьЗначенияСвойств(Запись, СтруктураСтроки);
	
	ХарактеристикиИспользуются = СтруктураСтроки.ХарактеристикиИспользуются;
	Элементы.Характеристика.Доступность = ХарактеристикиИспользуются;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
