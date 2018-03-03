﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Параметры.Свойство("СтатьяФинансированияДокумента",	СтатьяФинансированияДокумента);
	ВыделенныеСтроки.Загрузить(ПолучитьИзВременногоХранилища(Параметры.АдресВХранилищеВыделенныхСтрок));
	
	СтрокиСоСтатьейДокумента = ВыделенныеСтроки.НайтиСтроки(Новый Структура("СтатьяФинансирования", СтатьяФинансированияДокумента));
	Если СтрокиСоСтатьейДокумента.Количество() = 0 Тогда 
		// целевой статьи среди выделенных нет, все переносим на целевую статью
		СтатьяФинансирования = СтатьяФинансированияДокумента;
		Элементы.СтатьяФинансирования.ТолькоПросмотр = Истина;
	Иначе
		// выбраны строки с целевой статьей
		СтатьяФинансирования = Справочники.СтатьиФинансированияЗарплата.ПустаяСсылка();
	КонецЕсли;
	
	МаксимальнаяСуммаПереноса = ВыделенныеСтроки.Итог("Сумма");
	СуммаПоложительная = (МаксимальнаяСуммаПереноса>0);
	Если СуммаПоложительная Тогда
		Параметр1 = Формат(0.01, "ЧДЦ=2");
		Параметр2 = Формат(МаксимальнаяСуммаПереноса, "ЧДЦ=2");
	Иначе
		Параметр1 = Формат(МаксимальнаяСуммаПереноса, "ЧДЦ=2");
		Параметр2 = Формат(-0.01, "ЧДЦ=2"); 
	КонецЕсли;
	ШаблонСообщения = НСтр("ru = 'Допустимое значение суммы переноса от %1 до %2'");
	ИнфСтрока = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения, Параметр1, Параметр2);
	Элементы.Сумма.Подсказка = ИнфСтрока;
	
	Сумма = МаксимальнаяСуммаПереноса;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("ВыбратьИЗакрыть", ЭтотОбъект);
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(Оповещение, Отказ, ЗавершениеРаботы);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	ВыбратьИЗакрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Модифицированность = Ложь;
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции


&НаКлиенте
Процедура ВыбратьИЗакрыть(Результат = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт
	
	
	Если СуммаПоложительная И (Сумма > МаксимальнаяСуммаПереноса Или Сумма < 0) Или Не СуммаПоложительная И (Сумма < МаксимальнаяСуммаПереноса Или Сумма > 0)  Тогда
		ПоказатьПредупреждение(, ИнфСтрока); 
		Возврат;
	КонецЕсли;
	
	Если ПроверитьЗаполнение() Тогда
		
		РезультатыРедактирования = Новый Структура;
		РезультатыРедактирования.Вставить("СтатьяФинансирования", СтатьяФинансирования);
		РезультатыРедактирования.Вставить("СтатьяРасходов", СтатьяРасходов);
		РезультатыРедактирования.Вставить("СпособОтраженияЗарплатыВБухучете", СпособОтраженияЗарплатыВБухучете);
		РезультатыРедактирования.Вставить("Сумма", Сумма);
		
		Модифицированность = Ложь;
		Закрыть(РезультатыРедактирования)
		
	КонецЕсли
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

#КонецОбласти


