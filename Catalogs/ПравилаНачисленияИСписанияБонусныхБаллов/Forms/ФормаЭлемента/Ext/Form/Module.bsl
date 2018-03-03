﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	ПриСозданииЧтенииНаСервере();

	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);

	МодификацияКонфигурацииПереопределяемый.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);

КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	РазделениеВключено = ОбщегоНазначенияПовтИсп.РазделениеВключено();
	
	// Обработчик подсистемы "Свойства"
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Объект", Объект);
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтаФорма, ДополнительныеПараметры);
	
	// подсистема запрета редактирования ключевых реквизитов объектов	
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтаФорма);
	
	ПолучитьРасписаниеРегламентногоЗадания(ЭтаФорма);
	
	// Заполнение списка схем компоновки данных
	Элементы.СхемаКомпоновкиДанных.СписокВыбора.Очистить();
	
	ПризнакПредопределенногоМакета = Врег("Предопределенный");
	ДлинаПризнакаПредопределенногоМакета = СтрДлина(ПризнакПредопределенногоМакета);
	Для каждого Макет из Метаданные.НайтиПоТипу(ТипЗнч(Объект.Ссылка)).Макеты Цикл
		Если Макет.ТипМакета = Метаданные.СвойстваОбъектов.ТипМакета.СхемаКомпоновкиДанных Тогда
			
			Если ВРег(Прав(Макет.Имя, ДлинаПризнакаПредопределенногоМакета)) = ПризнакПредопределенногоМакета Тогда
				Элементы.СхемаКомпоновкиДанных.СписокВыбора.Добавить(Макет.Имя, Макет.Синоним);
			КонецЕсли;
			
		КонецЕсли;
	КонецЦикла;
	
	ИспользоватьПроизвольныеСхемыКомпоновкиДанных = Не ОбщегоНазначенияПовтИсп.РазделениеВключено();
	Если ИспользоватьПроизвольныеСхемыКомпоновкиДанных Тогда
		
		ПредставлениеПроизвольнойСхемы = НСтр("ru = 'Произвольный'");
		Элементы.СхемаКомпоновкиДанных.СписокВыбора.Добавить("", ПредставлениеПроизвольнойСхемы);
	
	КонецЕсли;
	
	СоответствиеНастроек = Новый Структура;
	ПредыдущаяСхемаКомпоновкиДанных = Объект.СхемаКомпоновкиДанных;
	ХранилищеНастроекКомпоновкиДанных = Объект.Ссылка.ХранилищеНастроекКомпоновкиДанных;
	ИспользуетсяПроизвольныйОтбор = ХранилищеНастроекКомпоновкиДанных.Получить() <> Неопределено;
	ХранилищеСхемыКомпоновкиДанных = Объект.Ссылка.ХранилищеСхемыКомпоновкиДанных;
	
	ПриСозданииЧтенииНаСервере();

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)

	// Подсистема "Свойства"
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтаФорма, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	
	Элементы.ГруппаРасписание.ТекущаяСтраница = Элементы.ГруппаРасписание.ПодчиненныеЭлементы.СтраницаРасписаниеНачисление;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтаФорма, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ТекущийОбъект.ДополнительныеСвойства.Вставить("Расписание", Расписание);
	ТекущийОбъект.ДополнительныеСвойства.Вставить("Использование", РегламентноеЗаданиеИспользуется);
	
	Если ЗначениеЗаполнено(ТекущийОбъект.СхемаКомпоновкиДанных) Тогда
		Схема = Справочники.ПравилаНачисленияИСписанияБонусныхБаллов.ПолучитьМакет(ТекущийОбъект.СхемаКомпоновкиДанных);
	Иначе
		Схема = ХранилищеСхемыКомпоновкиДанных.Получить();
	КонецЕсли;
	
	НастройкиКомпоновкиДанных = ХранилищеНастроекКомпоновкиДанных.Получить();
	
	Если Схема = Неопределено Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Схема компоновки данных не корректна.'"),
			,
			"Объект.СхемаКомпоновкиДанных",,
			Отказ);
	Иначе
		Для Каждого ПараметрСхемы Из Схема.Параметры Цикл
			
			Если ПараметрСхемы.ЗапрещатьНезаполненныеЗначения Тогда
				
				ВывестиСообщение = Ложь;
				Если НастройкиКомпоновкиДанных = Неопределено И Не ЗначениеЗаполнено(ПараметрСхемы.Значение) Тогда
				
					ВывестиСообщение = Истина;
					
				ИначеЕсли НастройкиКомпоновкиДанных <> Неопределено Тогда
					
					Параметр = НастройкиКомпоновкиДанных.ПараметрыДанных.Элементы.Найти(ПараметрСхемы.Имя);
					Если (Параметр = Неопределено И Не ЗначениеЗаполнено(ПараметрСхемы.Значение))
						Или (Параметр <> Неопределено И Не ЗначениеЗаполнено(Параметр.Значение))Тогда
						ВывестиСообщение = Истина;
					КонецЕсли;
					
				КонецЕсли;
				
				Если ВывестиСообщение Тогда
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
						СтрШаблон(НСтр("ru = 'Не заполнено значение параметра ""%1""'"), ПараметрСхемы.Имя),
						,
						"Объект.СхемаКомпоновкиДанных",,
						Отказ);
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЦикла;
	КонецЕсли;
	
	ТекущийОбъект.ХранилищеНастроекКомпоновкиДанных = ХранилищеНастроекКомпоновкиДанных;
	ТекущийОбъект.ХранилищеСхемыКомпоновкиДанных    = ХранилищеСхемыКомпоновкиДанных;
	
	// Обработчик подсистемы "Свойства"
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект);

	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// Обработчик подсистемы "Свойства"
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект);
	
	// подсистема запрета редактирования ключевых реквизитов объектов	
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтаФорма);

	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)

	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВидПравилаПриИзменении(Элемент)
	
	ЗаполнитьСписокВыбораСхемыКомпоновкиДанных();
	
	Если Элементы.СхемаКомпоновкиДанных.СписокВыбора.НайтиПоЗначению(Объект.СхемаКомпоновкиДанных) = Неопределено Тогда
		Объект.СхемаКомпоновкиДанных = Элементы.СхемаКомпоновкиДанных.СписокВыбора[0].Значение;
	КонецЕсли;
	
	Если (Объект.ВидПравила = ПредопределенноеЗначение("Перечисление.ВидыПравилНачисленияБонусныхБаллов.Списание")) Тогда
		
		ИспользоватьПериодДействия                      = 0;
		Объект.КоличествоПериодовДействия               = 0;
		ИспользоватьОтсрочкуНачалаДействия              = 0;
		Объект.КоличествоПериодовОтсрочкиНачалаДействия = 0;
		
	КонецЕсли;
	
	ИзменитьДоступность(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура СхемаКомпоновкиДанныхПриИзменении(Элемент)
	
	СхемаКомпоновкиДанныхПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьПериодДействияПриИзменении(Элемент)
	
	ИзменитьДоступность(ЭтаФорма);
	
	Объект.КоличествоПериодовДействия = ИспользоватьПериодДействия;
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьОтсрочкуНачалаДействияПриИзменении(Элемент)
	
	ИзменитьДоступность(ЭтаФорма);
	
	Объект.КоличествоПериодовОтсрочкиНачалаДействия = ИспользоватьОтсрочкуНачалаДействия;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура РедактироватьСхемуКомпоновкиДанных(Команда)
	
	// Открыть редактор настроек схемы компоновки данных
	ЗаголовокФормыНастройкиСхемыКомпоновкиДанных = НСтр("ru = 'Настройка схемы компоновки данных для автоматического начисления ""%1""'");
	ЗаголовокФормыНастройкиСхемыКомпоновкиДанных = СтрЗаменить(ЗаголовокФормыНастройкиСхемыКомпоновкиДанных, "%1", Объект.Наименование);
	
	Адреса = ПолучитьАдресаСхемыКомпоновкиДанныхВоВременномХранилище();
	
	АдресХранилищаНастройкиКомпоновщика = Неопределено;

	
	ОткрытьФорму("ОбщаяФорма.УпрощеннаяНастройкаСхемыКомпоновкиДанных",
		Новый Структура(
			"НеПомещатьНастройкиВСхемуКомпоновкиДанных,
			|НеРедактироватьСхемуКомпоновкиДанных,
			|НеЗагружатьСхемуКомпоновкиДанныхИзФайла,
			|НеНастраиватьУсловноеОформление,
			|НеНастраиватьВыбор,
			|НеНастраиватьПорядок,
			|УникальныйИдентификатор,
			|АдресСхемыКомпоновкиДанных,
			|АдресНастроекКомпоновкиДанных,
			|Заголовок",
			Истина,
			Ложь,
			Ложь,
			Истина,
			Истина,
			Истина,
			УникальныйИдентификатор,
			Адреса.СхемаКомпоновкиДанных,
			Адреса.НастройкиКомпоновкиДанных,
			ЗаголовокФормыНастройкиСхемыКомпоновкиДанных),,,,, Новый ОписаниеОповещения("РедактироватьСхемуКомпоновкиДанныхЗавершение", ЭтотОбъект, Новый Структура("Адреса", Адреса)), РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура РедактироватьСхемуКомпоновкиДанныхЗавершение(Результат, ДополнительныеПараметры) Экспорт
    
    Адреса = ДополнительныеПараметры.Адреса;
    
    
    АдресХранилищаНастройкиКомпоновщика = Результат;
    
    Если ЗначениеЗаполнено(АдресХранилищаНастройкиКомпоновщика) Тогда
        ПрименитьИзмененияКСхемеКомпоновкиДанных(Адреса.СхемаКомпоновкиДанных, АдресХранилищаНастройкиКомпоновщика);
    КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура НастроитьРасписание(Команда)
	
	ДиалогРасписания = Новый ДиалогРасписанияРегламентногоЗадания(Расписание);
	ДиалогРасписания.Показать(Новый ОписаниеОповещения("НастроитьРасписаниеЗавершение", ЭтотОбъект, Новый Структура("ДиалогРасписания", ДиалогРасписания)));
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьРасписаниеЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ДиалогРасписания = ДополнительныеПараметры.ДиалогРасписания;
	
	Если Результат <> Неопределено Тогда
		
		Модифицированность = Истина;
		Расписание         = ДиалогРасписания.Расписание;
		Если РазделениеВключено 
			И Расписание.ПериодПовтораВТечениеДня > 0
			И Расписание.ПериодПовтораВТечениеДня < 3600 Тогда
			
			Расписание.ПериодПовтораВТечениеДня = 3600;
			
		КонецЕсли;
		РасписаниеСтрокой  = Строка(Расписание);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъекта(Команда)
	
	ОбщегоНазначенияУТКлиент.РазрешитьРедактированиеРеквизитовОбъекта(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.Свойства

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

// Конец СтандартныеПодсистемы.Свойства

#Область Свойства

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_РедактироватьСоставСвойств()
	УправлениеСвойствамиКлиент.РедактироватьСоставСвойств(ЭтаФорма);
КонецПроцедуры

#КонецОбласти

#Область Прочие

&НаСервере
Процедура ЗаполнитьСписокВыбораСхемыКомпоновкиДанных()
	
	Элементы.СхемаКомпоновкиДанных.СписокВыбора.Очистить();
	
	// Заполнение списка схем компоновки данных
	ПризнакПредопределенногоМакета = Врег("Предопределенный");
	ПризнакСписание = Врег("Списание");
	ПризнакНачисление = Врег("Начисление");
	ДлинаПризнакаПредопределенногоМакета = СтрДлина(ПризнакПредопределенногоМакета);
	Для каждого Макет из Метаданные.НайтиПоТипу(ТипЗнч(Объект.Ссылка)).Макеты Цикл
		Если Макет.ТипМакета = Метаданные.СвойстваОбъектов.ТипМакета.СхемаКомпоновкиДанных Тогда
			
			Если ВРег(Прав(Макет.Имя, ДлинаПризнакаПредопределенногоМакета)) = ПризнакПредопределенногоМакета Тогда
				
				Если ВРег(Лев(Макет.Имя, СтрДлина(ПризнакСписание))) = ПризнакСписание
					И Объект.ВидПравила = Перечисления.ВидыПравилНачисленияБонусныхБаллов.Списание Тогда
				
					Элементы.СхемаКомпоновкиДанных.СписокВыбора.Добавить(Макет.Имя, Макет.Синоним);
				
				КонецЕсли;
				Если ВРег(Лев(Макет.Имя, СтрДлина(ПризнакНачисление))) = ПризнакНачисление
					И Объект.ВидПравила = Перечисления.ВидыПравилНачисленияБонусныхБаллов.Начисление Тогда
				
					Элементы.СхемаКомпоновкиДанных.СписокВыбора.Добавить(Макет.Имя, Макет.Синоним);
				
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
	КонецЦикла;
	
	Элементы.СхемаКомпоновкиДанных.СписокВыбора.Добавить("", НСтр("ru = 'Произвольный'"));
	
КонецПроцедуры

&НаСервере
Функция ПолучитьXML(Значение)
	
	Запись = Новый ЗаписьXML();
	Запись.УстановитьСтроку();
	СериализаторXDTO.ЗаписатьXML(Запись, Значение);
	Возврат Запись.Закрыть();
	
КонецФункции

&НаСервере
Функция ПрименитьИзмененияКСхемеКомпоновкиДанных(АдресСхемыКомпоновкиДанныхВХранилище, АдресНастроекКомпоновкиДанных)
	
	Если ЗначениеЗаполнено(Объект.СхемаКомпоновкиДанных) Тогда
		
		СхемаИНастройки = Справочники.ПравилаНачисленияИСписанияБонусныхБаллов.ПолучитьОписаниеИСхемуКомпоновкиДанныхПоИмениМакета(Объект.Ссылка, Объект.СхемаКомпоновкиДанных);
		
		// Если схема компоновки данных из макета <> полученной из редактора схеме компоновки данных
		Если ПолучитьXML(СхемаИНастройки.СхемаКомпоновкиДанных) <> ПолучитьXML(ПолучитьИзВременногоХранилища(АдресСхемыКомпоновкиДанныхВХранилище)) Тогда
			Объект.СхемаКомпоновкиДанных   = "";
			ХранилищеСхемыКомпоновкиДанных = Новый ХранилищеЗначения(ПолучитьИзВременногоХранилища(АдресСхемыКомпоновкиДанныхВХранилище));
		КонецЕсли;
		
		// Полученные настройки могут быть равны настройкам по умолчанию схемы.
		КомпоновщикНастроек = Новый КомпоновщикНастроекКомпоновкиДанных;
		КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаИНастройки.СхемаКомпоновкиДанных));
		КомпоновщикНастроек.ЗагрузитьНастройки(СхемаИНастройки.СхемаКомпоновкиДанных.НастройкиПоУмолчанию);
		КомпоновщикНастроек.Восстановить();
		Если ПолучитьXML(КомпоновщикНастроек.ПолучитьНастройки()) <> ПолучитьXML(ПолучитьИзВременногоХранилища(АдресНастроекКомпоновкиДанных)) Тогда
			ХранилищеНастроекКомпоновкиДанных = Новый ХранилищеЗначения(ПолучитьИзВременногоХранилища(АдресНастроекКомпоновкиДанных));
		Иначе
			ХранилищеНастроекКомпоновкиДанных = Новый ХранилищеЗначения(Неопределено);
		КонецЕсли;
		
	Иначе
		
		Схема = ПолучитьИзВременногоХранилища(АдресСхемыКомпоновкиДанныхВХранилище);
		ХранилищеСхемыКомпоновкиДанных = Новый ХранилищеЗначения(Схема);
		
		КомпоновщикНастроек = Новый КомпоновщикНастроекКомпоновкиДанных;
		КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(Схема));
		КомпоновщикНастроек.ЗагрузитьНастройки(Схема.НастройкиПоУмолчанию);
		КомпоновщикНастроек.Восстановить();
		Если ПолучитьXML(КомпоновщикНастроек.ПолучитьНастройки()) <> ПолучитьXML(ПолучитьИзВременногоХранилища(АдресНастроекКомпоновкиДанных)) Тогда
			ХранилищеНастроекКомпоновкиДанных = Новый ХранилищеЗначения(ПолучитьИзВременногоХранилища(АдресНастроекКомпоновкиДанных));
		Иначе
			ХранилищеНастроекКомпоновкиДанных = Новый ХранилищеЗначения(Неопределено);
		КонецЕсли;
		
	КонецЕсли;
	
	ИспользуетсяПроизвольныйОтбор = ХранилищеНастроекКомпоновкиДанных.Получить() <> Неопределено;
	
КонецФункции

&НаСервере
Функция ПолучитьАдресаСхемыКомпоновкиДанныхВоВременномХранилище()
	
	Адреса = Новый Структура("СхемаКомпоновкиДанных, НастройкиКомпоновкиДанных");
	
	// Схема
	Если ЗначениеЗаполнено(Объект.СхемаКомпоновкиДанных) ИЛИ ХранилищеСхемыКомпоновкиДанных = Неопределено Тогда
		СхемаИНастройки = Справочники.ПравилаНачисленияИСписанияБонусныхБаллов.ПолучитьОписаниеИСхемуКомпоновкиДанныхПоИмениМакета(Объект.Ссылка, Объект.СхемаКомпоновкиДанных);
		СхемаКомпоновкиДанных = СхемаИНастройки.СхемаКомпоновкиДанных;
	Иначе
		СхемаКомпоновкиДанных = ХранилищеСхемыКомпоновкиДанных.Получить();
	КонецЕсли;
	
	Если СхемаКомпоновкиДанных = Неопределено Тогда
		СхемаКомпоновкиДанных = Справочники.ПравилаНачисленияИСписанияБонусныхБаллов.СформироватьНовуюСхемуКомпоновкиДанных();
	КонецЕсли;
	
	Адреса.СхемаКомпоновкиДанных = ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, УникальныйИдентификатор);
	
	// Настройки
	Настройки = ХранилищеНастроекКомпоновкиДанных.Получить();
	Если ЗначениеЗаполнено(Настройки) Тогда
		Адреса.НастройкиКомпоновкиДанных = ПоместитьВоВременноеХранилище(Настройки, УникальныйИдентификатор);
	КонецЕсли;
	
	Возврат Адреса;
	
КонецФункции

&НаСервере
Процедура СохранитьНастройки()

	Ключ = ПредыдущаяСхемаКомпоновкиДанных + "Схема";
	
	АдресВоВременномХранилище = Неопределено;
	АдресВоВременномХранилище = СоответствиеНастроек.Свойство(Ключ, АдресВоВременномХранилище);
	
	Если ХранилищеНастроекКомпоновкиДанных = Неопределено Тогда
		ХранилищеНастроекКомпоновкиДанных = Новый ХранилищеЗначения(Неопределено);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(АдресВоВременномХранилище) Тогда
		АдресВоВременномХранилище = ПоместитьВоВременноеХранилище(
			ХранилищеНастроекКомпоновкиДанных,
			АдресВоВременномХранилище);
	Иначе
		АдресВоВременномХранилище = ПоместитьВоВременноеХранилище(
			ХранилищеНастроекКомпоновкиДанных,
			УникальныйИдентификатор);
	КонецЕсли;
	
	СоответствиеНастроек.Вставить(Ключ, АдресВоВременномХранилище);
	
КонецПроцедуры

&НаСервере
Процедура СхемаКомпоновкиДанныхПриИзмененииНаСервере()
	
	СохранитьНастройки();
	
	Ключ = Объект.СхемаКомпоновкиДанных + "Схема";
	
	АдресВоВременномХранилище = Неопределено;
	Если СоответствиеНастроек.Свойство(Ключ, АдресВоВременномХранилище) И ЗначениеЗаполнено(АдресВоВременномХранилище) Тогда
		ХранилищеНастроекКомпоновкиДанных = ПолучитьИзВременногоХранилища(АдресВоВременномХранилище);
	Иначе
		ХранилищеНастроекКомпоновкиДанных = Новый ХранилищеЗначения(Неопределено);
	КонецЕсли;
	
	ИспользуетсяПроизвольныйОтбор = ХранилищеНастроекКомпоновкиДанных.Получить() <> Неопределено;
	
	ПредыдущаяСхемаКомпоновкиДанных = Объект.СхемаКомпоновкиДанных;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииЧтенииНаСервере()
	
	ЗаполнитьСписокВыбораСхемыКомпоновкиДанных();
	
	ИспользоватьПериодДействия         = ?(Объект.КоличествоПериодовДействия > 0, 1, 0);
	ИспользоватьОтсрочкуНачалаДействия = ?(Объект.КоличествоПериодовОтсрочкиНачалаДействия > 0, 1, 0);
	
	ИзменитьДоступность(ЭтаФорма);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ИзменитьДоступность(Форма)
	
	Форма.Элементы.ГруппаСрокДействияПраво.Доступность = (Форма.ИспользоватьПериодДействия = 1);
	Форма.Элементы.ГруппаОтсрочкаПраво.Доступность     = (Форма.ИспользоватьОтсрочкуНачалаДействия = 1);
	
	Форма.Элементы.ГруппаСрокиДействия.Видимость       = (Форма.Объект.ВидПравила = ПредопределенноеЗначение("Перечисление.ВидыПравилНачисленияБонусныхБаллов.Начисление"));
	
	Форма.Элементы.ГруппаСрокиДействия.Видимость       = (Форма.Объект.ВидПравила = ПредопределенноеЗначение("Перечисление.ВидыПравилНачисленияБонусныхБаллов.Начисление"));
	
	Если Форма.Объект.ВидПравила = ПредопределенноеЗначение("Перечисление.ВидыПравилНачисленияБонусныхБаллов.Начисление") Тогда
		Форма.Элементы.ГруппаРасписание.ТекущаяСтраница    = Форма.Элементы.ГруппаРасписание.ПодчиненныеЭлементы.СтраницаРасписаниеНачисление;
	Иначе
		Форма.Элементы.ГруппаРасписание.ТекущаяСтраница    = Форма.Элементы.ГруппаРасписание.ПодчиненныеЭлементы.СтраницаРасписаниеСписание;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьРасписаниеРегламентногоЗадания(Форма)
	
	Форма.Расписание = Новый РасписаниеРегламентногоЗадания;
	
	Если Форма.Объект.Ссылка.Пустая() Тогда
		
		Форма.Расписание.ВремяНачала = '00010101020000'; // в 02:00
		Форма.Расписание.ВремяКонца  = '00010101060000'; // в 06:00
		Форма.Расписание.ПериодПовтораДней = 1; //каждый день
		
	Иначе
		
		УстановитьПривилегированныйРежим(Истина);
		ИдентификаторЗадания = Форма.Объект.РегламентноеЗадание;
		Если ТипЗнч(ИдентификаторЗадания) = Тип("УникальныйИдентификатор") Тогда
			Задание = РегламентныеЗаданияСервер.Задание(ИдентификаторЗадания);
			Если Задание <> Неопределено Тогда
				Форма.Расписание = Задание.Расписание;
				Форма.РегламентноеЗаданиеИспользуется = Задание.Использование;
				Форма.РасписаниеСтрокой = Строка(Форма.Расписание);
			КонецЕсли;
		КонецЕсли; 
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

