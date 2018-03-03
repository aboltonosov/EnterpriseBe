﻿////////////////////////////////////////////////////////////////////////////////
// ФизическиеЛицаЗарплатаКадры: методы, дополняющие функциональность справочника
// 		ФизическиеЛица.
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка) Экспорт
	
	ФизическиеЛицаЗарплатаКадрыРасширенныйПереопределяемый.ОбработкаПолученияФормыСправочникаФизическиеЛица(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка);
	
	Если Не СтандартнаяОбработка Тогда 
		Возврат;
	КонецЕсли;
	
	Если ВидФормы = "ФормаВыбора" Тогда
		
		Если Параметры.Свойство("Отбор") Тогда
			
			Если Параметры.Отбор.Свойство("Роль")
				И (Параметры.Отбор.Свойство("Организация")
					Или Параметры.Отбор.Свойство("ГоловнаяОрганизация")) Тогда
				
				Если Параметры.Отбор.Свойство("Организация") И ТипЗнч(Параметры.Отбор.Организация) = Тип("СправочникСсылка.Организации")
					Или Параметры.Отбор.Свойство("ГоловнаяОрганизация") И ТипЗнч(Параметры.Отбор.ГоловнаяОрганизация) = Тип("СправочникСсылка.Организации") Тогда
					
					СтандартнаяОбработка = Ложь;
					ВыбраннаяФорма = "ФормаВыбораПоРоли";
					Возврат;
					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	ФизическиеЛицаЗарплатаКадрыБазовый.ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка);
	
КонецПроцедуры

Функция ПредставлениеРолиВоМножественномЧисле(Роль) Экспорт
	Если Роль = Перечисления.РолиФизическихЛиц.Акционер Тогда
		Возврат НСтр("ru = 'Акционеры'");
	ИначеЕсли Роль = Перечисления.РолиФизическихЛиц.Сотрудник Тогда
		Возврат НСтр("ru = 'Сотрудники'");
	ИначеЕсли Роль = Перечисления.РолиФизическихЛиц.БывшийСотрудник Тогда
		Возврат НСтр("ru = 'Бывшие сотрудники'");
	ИначеЕсли Роль = Перечисления.РолиФизическихЛиц.ПрочийПолучательДоходов Тогда
		Возврат НСтр("ru = 'Прочие получатели доходов'");
	ИначеЕсли Роль = Перечисления.РолиФизическихЛиц.РаздатчикЗарплаты Тогда
		Возврат НСтр("ru = 'Раздатчики зарплаты'");
	Иначе
		Возврат "" + Роль;
	КонецЕсли;
		
КонецФункции

Функция ПредставлениеРолиВРодительномПадеже(Роль) Экспорт
	Если Роль = Перечисления.РолиФизическихЛиц.Акционер Тогда
		Возврат НСтр("ru = 'акционера'");
	ИначеЕсли Роль = Перечисления.РолиФизическихЛиц.Сотрудник Тогда
		Возврат НСтр("ru = 'сотрудника'");
	ИначеЕсли Роль = Перечисления.РолиФизическихЛиц.БывшийСотрудник Тогда
		Возврат НСтр("ru = 'бывшего сотрудника'");
	ИначеЕсли Роль = Перечисления.РолиФизическихЛиц.ПрочийПолучательДоходов Тогда
		Возврат НСтр("ru = 'прочего получателя доходов'");
	ИначеЕсли Роль = Перечисления.РолиФизическихЛиц.РаздатчикЗарплаты Тогда
		Возврат НСтр("ru = 'раздатчика зарплаты'");
	Иначе
		Возврат "" + Роль;
	КонецЕсли;
		
КонецФункции

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка) Экспорт
	
	Перем Организация;
	Перем Подразделение;
	Перем РольФизическогоЛица;
	Параметры.Отбор.Свойство("Организация", Организация);
	Параметры.Отбор.Свойство("Подразделение", Подразделение);
	Параметры.Отбор.Свойство("Роль", РольФизическогоЛица);
	
	Если РольФизическогоЛица = Неопределено Тогда
		ФизическиеЛицаЗарплатаКадрыБазовый.ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка);
	Иначе
		
		ЗапросТекст = 
		"ВЫБРАТЬ *
		|ИЗ
		|	Справочник.ФизическиеЛица КАК ФизическиеЛица
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.РолиФизическихЛиц КАК РолиФизическихЛиц
		|		ПО ФизическиеЛица.Ссылка = РолиФизическихЛиц.ФизическоеЛицо
		|ГДЕ
		|	РолиФизическихЛиц.Организация = &Организация
		|	И РолиФизическихЛиц.Роль = &РольФизическогоЛица
		|	И &ДополнительноеУсловие";
		
		ОрганизацияСписком = ТипЗнч(Организация) = Тип("Массив")
			Или ТипЗнч(Организация) = Тип("ФиксированныйМассив")
			Или ТипЗнч(Организация) = Тип("СписокЗначений");
			
		Если Организация = НеОпределено ИЛИ ОрганизацияСписком И Организация.Количество() = 0 Тогда
			ЗапросТекст = СтрЗаменить(ЗапросТекст, "РолиФизическихЛиц.Организация = &Организация
				|	И ", "");
		ИначеЕсли ОрганизацияСписком Тогда
			ЗапросТекст = СтрЗаменить(ЗапросТекст, "РолиФизическихЛиц.Организация = &Организация
				|	И ", "РолиФизическихЛиц.Организация В (&Организация)
				|	И ");
		КонецЕсли;
			
		РолиСписком = ТипЗнч(РольФизическогоЛица) = Тип("Массив")
			Или ТипЗнч(РольФизическогоЛица) = Тип("ФиксированныйМассив")
			Или ТипЗнч(РольФизическогоЛица) = Тип("СписокЗначений");
			
		Если РолиСписком И РольФизическогоЛица.Количество() = 0 Тогда
			ЗапросТекст = СтрЗаменить(ЗапросТекст, "РолиФизическихЛиц.Роль = &РольФизическогоЛица
				|	И ", "");
		ИначеЕсли РолиСписком Тогда
			ЗапросТекст = СтрЗаменить(ЗапросТекст, "РолиФизическихЛиц.Роль = &РольФизическогоЛица
				|	И ", "РолиФизическихЛиц.Роль В (&РольФизическогоЛица)
				|	И ");
		КонецЕсли;	
		
		Запрос = Новый Запрос;
		Запрос.Текст = ЗапросТекст;
		Запрос.УстановитьПараметр("Организация", Организация);
		Запрос.УстановитьПараметр("РольФизическогоЛица", РольФизическогоЛица);
		
		Если ЗначениеЗаполнено(ДанныеВыбора) И ДанныеВыбора.Количество() > 0 Тогда
			ИспользоватьДанныеВыбора = Истина;
		Иначе
			ИспользоватьДанныеВыбора = Ложь;
		КонецЕсли; 
		
		СтандартнаяОбработка = Ложь;
		
		ЗарплатаКадры.ЗаполнитьДанныеВыбораСправочника(ДанныеВыбора, Метаданные.Справочники.ФизическиеЛица, Параметры, Запрос, "ФизическиеЛица", ИспользоватьДанныеВыбора);
				
	КонецЕсли;
	
КонецПроцедуры

Процедура ФормаВыбораСотрудниковПриСозданииНаСервере(Форма, Параметры) Экспорт
	
	Если Параметры.Отбор.Свойство("Подразделение")
		И Параметры.Свойство("УчитыватьОтборПоПодразделению")
		И Параметры.УчитыватьОтборПоПодразделению
		И Не ПолучитьФункциональнуюОпцию("ВыполнятьРасчетЗарплатыПоПодразделениям") Тогда
		
		Параметры.Отбор.Удалить("Подразделение");
		
	КонецЕсли; 
	
	ТекстЗапроса = Форма.Список.ТекстЗапроса;
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,  "ТекущиеКадровыеДанныеСотрудников.ГоловнаяОрганизация КАК Организация,",
		"ТекущиеКадровыеДанныеСотрудников.ГоловнаяОрганизация КАК Организация,
		|	ТекущиеКадровыеДанныеСотрудников.ТекущийВидДоговора КАК ВидДоговора,");
		
	Форма.Список.ТекстЗапроса = ТекстЗапроса;
	Форма.Список.УстановитьОбязательноеИспользование("ВидДоговора", Истина);
	
КонецПроцедуры

Процедура ПеренестиФотографииФизическихЛицВРегистр(ПараметрыОбновления) Экспорт
	
	ОбновлениеИнформационнойБазы.УдалитьОтложенныйОбработчикИзОчереди("ФизическиеЛицаЗарплатаКадрыРасширенный.ПеренестиФотографииФизическихЛиц");
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1000
	|	ФизическиеЛица.Ссылка КАК ФизическоеЛицо,
	|	ФизическиеЛица.УдалитьФотографияФайлом КАК Фотография
	|ИЗ
	|	Справочник.ФизическиеЛица КАК ФизическиеЛица
	|ГДЕ
	|	ФизическиеЛица.УдалитьФотографияФайлом <> ЗНАЧЕНИЕ(Справочник.ФизическиеЛицаПрисоединенныеФайлы.ПустаяСсылка)";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ПараметрыОбновления.ОбработкаЗавершена = Ложь;
	Если РезультатЗапроса.Пустой() Тогда
		ПараметрыОбновления.ОбработкаЗавершена = Истина;
		Возврат;
	КонецЕсли;	

	Выборка = РезультатЗапроса.Выбрать();

	Пока Выборка.Следующий() Цикл 
		
		ДанныеФайла = ПрисоединенныеФайлы.ПолучитьДанныеФайла(Выборка.Фотография);
		
		ФотографииФизическихЛицМенеджерЗаписи = РегистрыСведений.ФотографииФизическихЛиц.СоздатьМенеджерЗаписи();
		ФотографииФизическихЛицМенеджерЗаписи.ФизическоеЛицо = Выборка.ФизическоеЛицо;
		ФотографииФизическихЛицМенеджерЗаписи.Фотография = Новый ХранилищеЗначения(ПолучитьИзВременногоХранилища(ДанныеФайла.СсылкаНаДвоичныеДанныеФайла));
		ФотографииФизическихЛицМенеджерЗаписи.Записать();
		
		ФизическоеЛицоОбъект = Выборка.ФизическоеЛицо.ПолучитьОбъект();
		ФизическоеЛицоОбъект.УдалитьФотографияФайлом = Справочники.ФизическиеЛицаПрисоединенныеФайлы.ПустаяСсылка();
		ФизическоеЛицоОбъект.ОбменДанными.Загрузка = Истина;
		ФизическоеЛицоОбъект.Записать();
		
		ПрисоединенныйФайлОбъект = Выборка.Фотография.ПолучитьОбъект();
		ПрисоединенныйФайлОбъект.Удалить();
		
	КонецЦикла;	
	
КонецПроцедуры

#КонецОбласти
