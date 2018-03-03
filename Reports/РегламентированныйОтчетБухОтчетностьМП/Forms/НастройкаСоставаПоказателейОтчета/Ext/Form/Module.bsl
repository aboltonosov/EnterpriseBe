﻿
&НаКлиенте
Перем ЗакрытиеЧерезКнопки;

#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ФлажкиУстановить(Команда)
	
	ПрисвоитьЗначениеФлажкам(НастройкиВФорме, Истина);
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ФлажкиСнять(Команда)
	
	ПрисвоитьЗначениеФлажкам(НастройкиВФорме, Ложь);
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ОК(Команда)
	
	ЗакрытиеЧерезКнопки = Истина;
	
	Если Модифицированность Тогда
		
		Закрыть(НастройкиВФорме);
		
	Иначе
		
		Закрыть();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьФорму(Команда)
	
	ЗакрытиеЧерезКнопки = Истина;
	
	Если Модифицированность Тогда
		
		ТекстВопроса = НСтр("ru='Состав дополнительных строк был изменен. Сохранить изменения?'");
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ЗакрытьФормуЗавершение", ЭтотОбъект);
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена);
		
	Иначе
		
		Закрыть();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьФормуЗавершение(ОтветПользователя, ДополнительныеПараметры) Экспорт
	
	Если ОтветПользователя = КодВозвратаДиалога.Да Тогда
		
		Закрыть(НастройкиВФорме);
		
	ИначеЕсли ОтветПользователя = КодВозвратаДиалога.Нет Тогда
		
		Закрыть();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	КопироватьДанныеФормы(Параметры.ДеревоНастроек, НастройкиВФорме);
    		
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если НЕ ЗакрытиеЧерезКнопки И Модифицированность Тогда
		
		Отказ = Истина;
		
		Если ЗавершениеРаботы Тогда
		
			ТекстПредупреждения = НСтр("ru='Состав дополнительных строк был изменен.
											|Перед завершением работы рекомендуется сохранить новый состав,
											|иначе изменения будут утеряны.'");
			
			Возврат;
		
		КонецЕсли;
		
		ТекстВопроса = НСтр("ru='Состав дополнительных строк был изменен. Сохранить изменения?'");
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект);
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		
		Модифицированность = Ложь;
		Закрыть(НастройкиВФорме);
		
	ИначеЕсли РезультатВопроса = КодВозвратаДиалога.Нет Тогда
		
		Модифицированность = Ложь;
		Закрыть();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПрисвоитьЗначениеФлажкам(ВетвьДерева, ЗначениеФлажка)

	Для Каждого СтрокаДерева Из ВетвьДерева.ПолучитьЭлементы() Цикл
		
		СтрокаДерева.ВключатьВОтчет = ЗначениеФлажка;
		
		Если СтрокаДерева.ПолучитьЭлементы().Количество() > 0 Тогда
			
			ПрисвоитьЗначениеФлажкам(СтрокаДерева, ЗначениеФлажка);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ЕстьРасширяемыеСтроки(ВетвьДерева)

	Для Каждого СтрокаДерева Из ВетвьДерева.ПолучитьЭлементы() Цикл
		Если НЕ ПустаяСтрока(СтрокаДерева.ТипСостава) Тогда
			Возврат Истина;
		Иначе
			Если СтрокаДерева.ПолучитьЭлементы().Количество() > 0 Тогда
				Если ЕстьРасширяемыеСтроки(СтрокаДерева) Тогда
					Возврат Истина;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции

&НаКлиенте
Процедура НастройкиВФормеВключатьВОтчетПриИзменении(Элемент)
	
	Модифицированность = Истина;
	
	Если Элементы.НастройкиВФорме.ТекущиеДанные.ВключатьВОтчет = 2 Тогда
		Элементы.НастройкиВФорме.ТекущиеДанные.ВключатьВОтчет = 0;
	КонецЕсли;
	
	Если Элементы.НастройкиВФорме.ТекущиеДанные.ПолучитьРодителя() = Неопределено
	   И Элементы.НастройкиВФорме.ТекущиеДанные.ПолучитьЭлементы().Количество() = 0 Тогда
	   
	   Возврат;
	   
   	КонецЕсли;
    	
	ИзменитьПометкуПодчиненных(Элементы.НастройкиВФорме.ТекущиеДанные, , , Истина, НастройкиВФорме);
			
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьПометкуПодчиненных(Узел, ВключатьВОтчет = Неопределено, СписокВыбранных = Неопределено, ОбновлятьПометкуРодительских = Ложь, Дерево = Неопределено)
	
	Если ВключатьВОтчет = Неопределено Тогда
		ВключатьВОтчет = Узел.ВключатьВОтчет;
	КонецЕсли;
	
	Если Дерево = Неопределено Тогда
		Дерево = Узел;
	КонецЕсли;
	
	Если СписокВыбранных = Неопределено Тогда
		Для Каждого Стр1 Из Узел.ПолучитьЭлементы() Цикл
			Для Каждого Стр2 Из Стр1.ПолучитьЭлементы() Цикл
				Для Каждого Стр3 Из Стр2.ПолучитьЭлементы() Цикл
					Для Каждого Стр4 Из Стр3.ПолучитьЭлементы() Цикл
						Стр4.ВключатьВОтчет = ВключатьВОтчет;
					КонецЦикла;
					Стр3.ВключатьВОтчет = ВключатьВОтчет;
				КонецЦикла;
				Стр2.ВключатьВОтчет = ВключатьВОтчет;
			КонецЦикла;
			Стр1.ВключатьВОтчет = ВключатьВОтчет;
		КонецЦикла;
	Иначе
		Для Каждого Стр1 Из Дерево.ПолучитьЭлементы() Цикл
			Для Каждого Стр2 Из Стр1.ПолучитьЭлементы() Цикл
				Для Каждого Стр3 Из Стр2.ПолучитьЭлементы() Цикл
					Для Каждого Стр4 Из Стр3.ПолучитьЭлементы() Цикл
						Стр4.ВлючатьВОтчет = Число(СписокВыбранных.НайтиПоЗначению(Стр4.Ссылка) <> Неопределено);
					КонецЦикла;
					Стр3.ВключатьВОтчет = Число(СписокВыбранных.НайтиПоЗначению(Стр3.Ссылка) <> Неопределено);
				КонецЦикла;
				Стр2.ВключатьВОтчет = Число(СписокВыбранных.НайтиПоЗначению(Стр2.Ссылка) <> Неопределено);
			КонецЦикла;
			Если Стр1.ПолучитьРодителя() <> Неопределено Тогда
				Стр1.ВключатьВОтчет = Число(СписокВыбранных.НайтиПоЗначению(Стр1.Ссылка) <> Неопределено);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Для Каждого Стр1 Из Дерево.ПолучитьЭлементы() Цикл
		
		Если Стр1.ПолучитьРодителя() <> Неопределено
		 ИЛИ Стр1.ПолучитьЭлементы().Количество() = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		СуммаПометок = 0;
		
		Для Каждого Стр2 Из Стр1.ПолучитьЭлементы() Цикл
						
			Если Стр2.ПолучитьЭлементы().Количество() = 0 Тогда
				СуммаПометок = СуммаПометок + Число(Стр2.ВключатьВОтчет);
				Продолжить;
			КонецЕсли;
			
			СуммаПометок2 = 0;
			
			Для Каждого Стр3 Из Стр2.ПолучитьЭлементы() Цикл
								
				Если Стр3.ПолучитьЭлементы().Количество() = 0 Тогда
					СуммаПометок2 = СуммаПометок2 + Число(Стр3.ВключатьВОтчет);
					Продолжить;
				КонецЕсли;
				
				СуммаПометок3 = 0;
								
				Для Каждого Стр4 Из Стр3.ПолучитьЭлементы() Цикл
					
					СуммаПометок3 = СуммаПометок3 + Число(Стр4.ВключатьВОтчет);
										
				КонецЦикла;
				
				Если СуммаПометок3 = Стр3.ПолучитьЭлементы().Количество() Тогда
					Стр3.ВключатьВОтчет = 1;
				ИначеЕсли СуммаПометок3 = 0 Тогда
					Стр3.ВключатьВОтчет = 0;
				Иначе
					Стр3.ВключатьВОтчет = 2;
				КонецЕсли;
				
				СуммаПометок2 = СуммаПометок2 + Число(Стр3.ВключатьВОтчет);
															
			КонецЦикла;
			
			Если СуммаПометок2 = Стр2.ПолучитьЭлементы().Количество() Тогда
				Стр2.ВключатьВОтчет = 1;
			ИначеЕсли СуммаПометок2 = 0 Тогда
				Стр2.ВключатьВОтчет = 0;
			Иначе
				Стр2.ВключатьВОтчет = 2;
			КонецЕсли;
			
			СуммаПометок = СуммаПометок + Число(Стр2.ВключатьВОтчет);
			
		КонецЦикла;
				
		Если СуммаПометок = Стр1.ПолучитьЭлементы().Количество() Тогда
			Стр1.ВключатьВОтчет = 1;
		ИначеЕсли СуммаПометок = 0 Тогда
			Стр1.ВключатьВОтчет = 0;
		Иначе
			Стр1.ВключатьВОтчет = 2;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

ЗакрытиеЧерезКнопки = Ложь;