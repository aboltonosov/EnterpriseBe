﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Ведомости = ЭтотОбъект.ВыгрузитьКолонку("Ведомость");
	Организации = ОбщегоНазначения.ЗначениеРеквизитаОбъектов(Ведомости, "Организация");
	Для Каждого Запись Из ЭтотОбъект Цикл
		Запись.Организация = Организации[Запись.Ведомость];
	КонецЦикла;
	
	Если Не ЭтотОбъект.ДополнительныеСвойства.Свойство("ВыполнятьПроверкуПередЗаписьюНабора")
		Или ЭтотОбъект.ДополнительныеСвойства.ВыполнятьПроверкуПередЗаписьюНабора Тогда
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("НаборЗаписей", ЭтотОбъект);
		
		Запрос.Текст =
		"ВЫБРАТЬ
		|	НаборЗаписей.ПлатежныйДокумент КАК ПлатежныйДокумент,
		|	НаборЗаписей.Ведомость КАК Ведомость
		|ПОМЕСТИТЬ ВТНаборЗаписей
		|ИЗ
		|	&НаборЗаписей КАК НаборЗаписей
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	НаборЗаписей.ПлатежныйДокумент КАК ПлатежныйДокумент,
		|	НаборЗаписей.Ведомость КАК Ведомость
		|ИЗ
		|	ВТНаборЗаписей КАК НаборЗаписей
		|
		|УПОРЯДОЧИТЬ ПО
		|	НаборЗаписей.ПлатежныйДокумент";
		
		МассивОшибок = Новый Массив;
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.СледующийПоЗначениюПоля("ПлатежныйДокумент") Цикл
			МассивВедомостей = Новый Массив;
			Пока Выборка.Следующий() Цикл
				МассивВедомостей.Добавить(Выборка.Ведомость);
			КонецЦикла;
			ОбменСБанкамиПоЗарплатнымПроектам.ПроверитьЗаполнениеПлатежногоДокумента(Выборка.ПлатежныйДокумент, МассивВедомостей, МассивОшибок);
		КонецЦикла;
		
		Для каждого Ошибка Из МассивОшибок Цикл
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Ошибка.ТекстСообщения, Ошибка.Ведомость, , , Отказ);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
