﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Синхронизация данных"
// Серверные процедуры, обслуживающие правила регистрации объектов.
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Регистрирует изменения для связанных с объектом присоединенных файлов и регистров сведений
//
// Параметры:
//  ИмяПланаОбмена - Строка - Имя метаданных плана обмена
//  Отказ - Булево - флаг отказа от выполнения правил регистрации.
//      Отказ от выполнения правил означает, что объект и присоединенные файлы не будет зарегистрированы на узлах плана обмена,
//      для которого создано это правило.
//  Объект - Объект, который может содержать присоединенные файлы.
//  ОбъектМетаданных - объект метаданных, соответствующий параметру Объект.
//  Выгрузка - (только чтение) - Булево - параметр определяет контекст выполнения правила регистрации.
//      Истина - правило регистрации выполняется в контексте выгрузки объекта.
//      Ложь - правило регистрации выполняется в контексте перед записью объекта
//  Получатели - Массив - список узлов-получателей, на которых будут зарегистрированы изменения для присоединенных файлов.
//
Процедура ЗарегистрироватьСвязанныеПрисоединенныеФайлыИРегистрыСведенийОбъекта(ИмяПланаОбмена, Отказ, Объект, ОбъектМетаданных, Выгрузка, Получатели) Экспорт
	
	Если Выгрузка Или Получатели.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	МассивФайлов = Новый Массив;
	ПрисоединенныеФайлы.ПолучитьПрикрепленныеФайлыКОбъекту(Объект.Ссылка, МассивФайлов);
	
	Для Каждого Элемент Из МассивФайлов Цикл
		ПланыОбмена.ЗарегистрироватьИзменения(Получатели, Элемент.ПолучитьОбъект());
	КонецЦикла;
	
	ЗарегистрироватьСвязанныеРегистрыСведенийОбъекта(
		ИмяПланаОбмена, Отказ, Объект, ОбъектМетаданных, Выгрузка, Получатели);
		
КонецПроцедуры

// Регистрирует изменения для регистров сведений, в которых объект присутствует в ведущем измерении
//
// Параметры:
//  ИмяПланаОбмена - Строка - Имя метаданных плана обмена
//  Отказ - Булево - флаг отказа от выполнения правил регистрации.
//      Отказ от выполнения правил означает, что объект и присоединенные файлы не будет зарегистрированы на узлах плана обмена,
//      для которого создано это правило.
//  Объект - Объект, который может содержать присоединенные файлы.
//  ОбъектМетаданных - объект метаданных, соответствующий параметру Объект.
//  Выгрузка - (только чтение) - Булево - параметр определяет контекст выполнения правила регистрации.
//      Истина - правило регистрации выполняется в контексте выгрузки объекта.
//      Ложь - правило регистрации выполняется в контексте перед записью объекта
//  Получатели - Массив - список узлов-получателей, на которых будут зарегистрированы изменения для присоединенных файлов.
//
Процедура ЗарегистрироватьСвязанныеРегистрыСведенийОбъекта(ИмяПланаОбмена, Отказ, Объект, ОбъектМетаданных, Выгрузка, Получатели) Экспорт
	
	Если Выгрузка Или Получатели.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	МассивСвязанныхДанных = Новый Структура;
	
	МассивСлужебныхРегистров = Новый Массив;
	МассивСлужебныхРегистров.Добавить("СоответствияОбъектовИнформационныхБаз");
	
	Для Каждого Состав Из Метаданные.ПланыОбмена[ИмяПланаОбмена].Состав Цикл
		МДСостава = Состав.Метаданные;
		Если Не ОбщегоНазначения.ЭтоРегистрСведений(МДСостава) Тогда
			Продолжить;
		КонецЕсли;
		Если МассивСлужебныхРегистров.Найти(МДСостава.Имя) <> Неопределено Тогда
			Продолжить;
		КонецЕсли;
		Если МДСостава.РежимЗаписи = Метаданные.СвойстваОбъектов.РежимЗаписиРегистра.ПодчинениеРегистратору Тогда
			Продолжить;
		КонецЕсли;
		
		Для Каждого Измерение Из Состав.Метаданные.Измерения Цикл
			Если Не Измерение.Ведущее Тогда
				Продолжить;
			КонецЕсли;
			
			Для Каждого ТипИзмерения Из Измерение.Тип.Типы() Цикл
				Если Метаданные.НайтиПоТипу(ТипИзмерения) = ОбъектМетаданных Тогда
					МассивСвязанныхДанных.Вставить(Состав.Метаданные.Имя, Измерение.Имя);
					Прервать;
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
	КонецЦикла;
	
	Для Каждого СвязанныеДанные Из МассивСвязанныхДанных Цикл
		
		МетаданныеРС = Метаданные.РегистрыСведений[СвязанныеДанные.Ключ];
		ИзмеренияРС = МетаданныеРС.Измерения;
		
		Запрос = Новый Запрос;
		
		Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
		
		Запрос.Текст = "
		| ВЫБРАТЬ РАЗЛИЧНЫЕ ";
		
		Для каждого ИзмерениеРС Из ИзмеренияРС Цикл
			Запрос.Текст = Запрос.Текст + "СвязанныеДанные." + ИзмерениеРС.Имя + ", ";
		КонецЦикла;
		Если МетаданныеРС.ПериодичностьРегистраСведений <> Метаданные.СвойстваОбъектов.ПериодичностьРегистраСведений.Непериодический Тогда
			Запрос.Текст = Запрос.Текст + "СвязанныеДанные.Период, ";
		КонецЕсли;
		
		СтроковыеФункцииКлиентСервер.УдалитьПоследнийСимволВСтроке(Запрос.Текст, 2);
		
		Запрос.Текст = Запрос.Текст + "
		| Из
		| РегистрСведений." + СвязанныеДанные.Ключ + " КАК СвязанныеДанные
		| ГДЕ
		| СвязанныеДанные." + СвязанныеДанные.Значение + " = &Ссылка";
		
		Выборка = Запрос.Выполнить().Выбрать();
		
		НаборЗаписей = РегистрыСведений[СвязанныеДанные.Ключ].СоздатьНаборЗаписей();
		
		Пока Выборка.Следующий() Цикл
			Для каждого ИзмерениеРС Из ИзмеренияРС Цикл
				НаборЗаписей.Отбор[ИзмерениеРС.Имя].Установить(Выборка[ИзмерениеРС.Имя]);
			КонецЦикла;
			Если МетаданныеРС.ПериодичностьРегистраСведений <> Метаданные.СвойстваОбъектов.ПериодичностьРегистраСведений.Непериодический Тогда
				НаборЗаписей.Отбор.Период.Установить(Выборка.Период);
			КонецЕсли;
			НаборЗаписей.Прочитать();
			
			ПланыОбмена.ЗарегистрироватьИзменения(Получатели, НаборЗаписей);
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

// Заменяет текст запроса регистрации изменений подчиненного объекта для получения списка узлов-получателей, как у объекта владельца
//
// Параметры:
//  ИмяПланаОбмена - Строка - Имя метаданных плана обмена
//  Отказ - Булево - флаг отказа от выполнения правил регистрации.
//      Отказ от выполнения правил означает, что объект и присоединенные файлы не будет зарегистрированы на узлах плана обмена,
//      для которого создано это правило.
//  ТекстЗапроса - Строка - текст запроса, который будет использован для определения узлов-получателей.
//  ПараметрыЗапроса - Структура - содержит значения свойств текущей версии объекта,
//      которые используются в качестве параметров в запросе для определения узлов-получателей.
//  ИспользоватьКэш - Булево - параметр определяет включение платформенного механизма повторно используемых значений
//      при определении узлов-получателей. Если передаваемые запросу значения в структуре ПараметрыЗапроса содержат недопустимые типы данных
//      для платформенного механизма кэширования, то флаг следует сбросить. Значение по умолчанию - Истина.
//  Выгрузка - (только чтение) - Булево - параметр определяет контекст выполнения правила регистрации.
//      Истина - правило регистрации выполняется в контексте выгрузки объекта.
//      Ложь - правило регистрации выполняется в контексте перед записью объекта
//  ОбъектВладелец - Объект, узлы-получатели которого будут использоваться для регистрации изменений подчиненного объекта
//
Процедура ОграничитьРегистрациюПодчиненногоОбъектаПоРегистрацииОбъектаВладельца(ИмяПланаОбмена, Отказ, ТекстЗапроса, ПараметрыЗапроса, ИспользоватьКэш, Выгрузка, ОбъектВладелец) Экспорт
	
	ИспользоватьКэш = Ложь;
	
	ПолучателиОбъектаВладельца = ОбменДаннымиСобытия.ОпределитьПолучателей(ОбъектВладелец, ИмяПланаОбмена);
	ПараметрыЗапроса.Вставить("ПолучателиОбъектаВладельца", ПолучателиОбъектаВладельца);
	
	ТекстЗапроса =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ПланОбменаОсновнаяТаблица.Ссылка КАК Ссылка
	|ИЗ
	|	#ПланОбмена КАК ПланОбменаОсновнаяТаблица
	|ГДЕ
	|	ПланОбменаОсновнаяТаблица.Ссылка В(&СвойствоОбъекта_ПолучателиОбъектаВладельца)";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "#ПланОбмена",
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='ПланОбмена.%1'"), ИмяПланаОбмена));
	
КонецПроцедуры

// Заменяет текст запроса регистрации изменений объекта для получения списка узлов-получателей по организации
//
// Параметры:
//  ИмяПланаОбмена - Строка - Имя метаданных плана обмена
//  Отказ - Булево - флаг отказа от выполнения правил регистрации.
//      Отказ от выполнения правил означает, что объект и присоединенные файлы не будет зарегистрированы на узлах плана обмена,
//      для которого создано это правило.
//  ТекстЗапроса - Строка - текст запроса, который будет использован для определения узлов-получателей.
//  ПараметрыЗапроса - Структура - содержит значения свойств текущей версии объекта,
//      которые используются в качестве параметров в запросе для определения узлов-получателей.
//  ИспользоватьКэш - Булево - параметр определяет включение платформенного механизма повторно используемых значений
//      при определении узлов-получателей. Если передаваемые запросу значения в структуре ПараметрыЗапроса содержат недопустимые типы данных
//      для платформенного механизма кэширования, то флаг следует сбросить. Значение по умолчанию - Истина.
//  Выгрузка - (только чтение) - Булево - параметр определяет контекст выполнения правила регистрации.
//      Истина - правило регистрации выполняется в контексте выгрузки объекта.
//      Ложь - правило регистрации выполняется в контексте перед записью объекта
//  Организации - Ссылка или массив ссылок на организации, по которым нужно получить список узлов-получателей
//
Процедура ОграничитьРегистрациюОбъектаОтборомПоОрганизациям(ИмяПланаОбмена, Отказ, ТекстЗапроса, ПараметрыЗапроса, ИспользоватьКэш, Выгрузка, Организации) Экспорт
	
	ИспользоватьКэш = Ложь;
	
	ПараметрыЗапроса.Вставить("Организации", Организации);
	
	ТекстЗапроса =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ПланОбменаОсновнаяТаблица.Ссылка КАК Ссылка
	|ИЗ
	|	#ПланОбмена КАК ПланОбменаОсновнаяТаблица
	|		ЛЕВОЕ СОЕДИНЕНИЕ #ПланОбменаОрганизации КАК ПланОбменаОрганизации
	|		ПО (ПланОбменаОрганизации.Ссылка = ПланОбменаОсновнаяТаблица.Ссылка)
	|ГДЕ
	|	ПланОбменаОрганизации.Организация В(&СвойствоОбъекта_Организации)
	|	И ПланОбменаОсновнаяТаблица.Ссылка <> &ИмяПланаОбменаЭтотУзел
	|	И НЕ ПланОбменаОсновнаяТаблица.ПометкаУдаления
	|	И &УсловиеОтбораПоРеквизитуФлагу
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ПланОбменаОсновнаяТаблица.Ссылка
	|ИЗ
	|	#ПланОбмена КАК ПланОбменаОсновнаяТаблица
	|		ЛЕВОЕ СОЕДИНЕНИЕ #ПланОбменаОрганизации КАК ПланОбменаОрганизации
	|		ПО (ПланОбменаОрганизации.Ссылка = ПланОбменаОсновнаяТаблица.Ссылка)
	|ГДЕ
	|	ПланОбменаОсновнаяТаблица.Ссылка <> &ИмяПланаОбменаЭтотУзел
	|	И НЕ ПланОбменаОсновнаяТаблица.ПометкаУдаления
	|	И &УсловиеОтбораПоРеквизитуФлагу
	|
	|СГРУППИРОВАТЬ ПО
	|	ПланОбменаОсновнаяТаблица.Ссылка
	|
	|ИМЕЮЩИЕ
	|	КОЛИЧЕСТВО(ПланОбменаОрганизации.Организация) = 0";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "#ПланОбменаОрганизации",
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='ПланОбмена.%1.Организации'"), ИмяПланаОбмена));
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "#ПланОбмена",
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='ПланОбмена.%1'"), ИмяПланаОбмена));
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ИмяПланаОбменаЭтотУзел",
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='&%1ЭтотУзел'"), ИмяПланаОбмена));
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "И &УсловиеОтбораПоРеквизитуФлагу", "[УсловиеОтбораПоРеквизитуФлагу]");
	
КонецПроцедуры

// Заменяет текст запроса регистрации изменений физических лиц для получения списка узлов-получателей по организациям,
// в которых установлены трудовые отношения по этим физическим лицам
//
// Параметры:
//  ИмяПланаОбмена - Строка - Имя метаданных плана обмена
//  Отказ - Булево - флаг отказа от выполнения правил регистрации.
//      Отказ от выполнения правил означает, что объект и присоединенные файлы не будет зарегистрированы на узлах плана обмена,
//      для которого создано это правило.
//  ТекстЗапроса - Строка - текст запроса, который будет использован для определения узлов-получателей.
//  ПараметрыЗапроса - Структура - содержит значения свойств текущей версии объекта,
//      которые используются в качестве параметров в запросе для определения узлов-получателей.
//  ИспользоватьКэш - Булево - параметр определяет включение платформенного механизма повторно используемых значений
//      при определении узлов-получателей. Если передаваемые запросу значения в структуре ПараметрыЗапроса содержат недопустимые типы данных
//      для платформенного механизма кэширования, то флаг следует сбросить. Значение по умолчанию - Истина.
//  Выгрузка - (только чтение) - Булево - параметр определяет контекст выполнения правила регистрации.
//      Истина - правило регистрации выполняется в контексте выгрузки объекта.
//      Ложь - правило регистрации выполняется в контексте перед записью объекта
//  ФизическиеЛица - Ссылка или массив ссылок физических лиц, по которым нужно получить список узлов-получателей
//  ДополнительныеПараметрыПолученияСотрудников - Структура параметров, которые будут использоваться для получения списка сотрудников физического лица
//
Процедура ОграничитьРегистрациюОбъектаОтборомПоФизическимЛицамСТрудовымиОтношениями(ИмяПланаОбмена, Отказ, ТекстЗапроса, ПараметрыЗапроса, ИспользоватьКэш, Выгрузка, ФизическиеЛица, ДополнительныеПараметрыПолученияСотрудников = Неопределено) Экспорт
	
	ПараметрыПолученияСотрудников = КадровыйУчет.ПараметрыПолученияСотрудниковОрганизацийПоСпискуФизическихЛиц();
	ПараметрыПолученияСотрудников.Вставить("КадровыеДанные",				"Организация");
	ПараметрыПолученияСотрудников.Вставить("СписокФизическихЛиц",			ФизическиеЛица);
	Если ТипЗнч(ДополнительныеПараметрыПолученияСотрудников) = Тип("Структура") Тогда
		Для Каждого Параметр Из ДополнительныеПараметрыПолученияСотрудников Цикл
			ПараметрыПолученияСотрудников.Вставить(Параметр.Ключ, Параметр.Значение)
		КонецЦикла;
	КонецЕсли;
	
	ПрисутствующиеОрганизации = КадровыйУчет.СотрудникиОрганизации(Ложь, ПараметрыПолученияСотрудников).ВыгрузитьКолонку("Организация");
	
	// Дополнение массива организаций индивидуальными предпринимателями
	Запрос = Новый Запрос;
	Запрос.Параметры.Вставить("ФизическиеЛица", ФизическиеЛица);
	Запрос.Параметры.Вставить("ПрисутствующиеОрганизации", ПрисутствующиеОрганизации);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Организации.Ссылка КАК Организация
	|ИЗ
	|	Справочник.Организации КАК Организации
	|ГДЕ
	|	Организации.ЮридическоеФизическоеЛицо = ЗНАЧЕНИЕ(Перечисление.ЮридическоеФизическоеЛицо.ФизическоеЛицо)
	|	И Организации.ИндивидуальныйПредприниматель В(&ФизическиеЛица)
	|	И НЕ Организации.Ссылка В (&ПрисутствующиеОрганизации)";
	
	Организации = Запрос.Выполнить().Выгрузить();
	
	Если Организации.Количество() > 0 Тогда
		ДополнительныеОрганизации = Организации.ВыгрузитьКолонку("Организация");
		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(ПрисутствующиеОрганизации, ДополнительныеОрганизации);
	КонецЕсли;
	
	Если ПрисутствующиеОрганизации.Количество() = 0 И ДополнительныеПараметрыПолученияСотрудников.Свойство("ТолькоСТрудовымиОтношениями") И ДополнительныеПараметрыПолученияСотрудников.ТолькоСТрудовымиОтношениями Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	ОграничитьРегистрациюОбъектаОтборомПоОрганизациям(ИмяПланаОбмена, Отказ, ТекстЗапроса, ПараметрыЗапроса, ИспользоватьКэш, Выгрузка, ПрисутствующиеОрганизации);
	
КонецПроцедуры

// Заменяет текст запроса регистрации изменений сотрудников для получения списка узлов-получателей по организациям,
// в которых установлены трудовые отношения по этим сотрудникам
//
// Параметры:
//  ИмяПланаОбмена - Строка - Имя метаданных плана обмена
//  Отказ - Булево - флаг отказа от выполнения правил регистрации.
//      Отказ от выполнения правил означает, что объект и присоединенные файлы не будет зарегистрированы на узлах плана обмена,
//      для которого создано это правило.
//  ТекстЗапроса - Строка - текст запроса, который будет использован для определения узлов-получателей.
//  ПараметрыЗапроса - Структура - содержит значения свойств текущей версии объекта,
//      которые используются в качестве параметров в запросе для определения узлов-получателей.
//  ИспользоватьКэш - Булево - параметр определяет включение платформенного механизма повторно используемых значений
//      при определении узлов-получателей. Если передаваемые запросу значения в структуре ПараметрыЗапроса содержат недопустимые типы данных
//      для платформенного механизма кэширования, то флаг следует сбросить. Значение по умолчанию - Истина.
//  Выгрузка - (только чтение) - Булево - параметр определяет контекст выполнения правила регистрации.
//      Истина - правило регистрации выполняется в контексте выгрузки объекта.
//      Ложь - правило регистрации выполняется в контексте перед записью объекта
//  Сотрудники - Ссылка или массив ссылок сотрудников, по которым нужно получить список узлов-получателей
//  ДатаСведений - дата на которую необходимо получить данные сотрудников, применимо к данным, носящим периодический характер
//      Если дату не указывать, будут получены самые последние данные.
//  ДополнительныеОрганизации - массив организаций, которые будут использоваться для получения списка узлов-получателей
//
Процедура ОграничитьРегистрациюОбъектаОтборомПоОрганизациямСотрудников(ИмяПланаОбмена, Отказ, ТекстЗапроса, ПараметрыЗапроса, ИспользоватьКэш, Выгрузка, Сотрудники, ДатаСведений = '00010101', ДополнительныеОрганизации = Неопределено) Экспорт
	
	ПрисутствующиеОрганизации = КадровыйУчет.КадровыеДанныеСотрудников(Ложь, Сотрудники, "Организация", ДатаСведений).ВыгрузитьКолонку("Организация");
	
	Если ТипЗнч(ДополнительныеОрганизации) = Тип("Массив") И ДополнительныеОрганизации.Количество() > 0 Тогда
		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(ПрисутствующиеОрганизации, ДополнительныеОрганизации, Истина);
	КонецЕсли;
	
	ОграничитьРегистрациюОбъектаОтборомПоОрганизациям(ИмяПланаОбмена, Отказ, ТекстЗапроса, ПараметрыЗапроса, ИспользоватьКэш, Выгрузка, ПрисутствующиеОрганизации);
	
КонецПроцедуры

// Ограничивает регистрацию изменений регистра сведений по типу измерения
// Используется для измерений регистра сведений с составным типом
//
// Параметры:
//  ИмяПланаОбмена - Строка - Имя метаданных плана обмена
//  Отказ - Булево - флаг отказа от выполнения правил регистрации.
//      Отказ от выполнения правил означает, что объект и присоединенные файлы не будет зарегистрированы на узлах плана обмена,
//      для которого создано это правило.
//  Объект - Запись регистра сведений, для которой регистрируется изменение.
//  ОбъектМетаданных - объект метаданных, соответствующий параметру Объект.
//  Выгрузка - (только чтение) - Булево - параметр определяет контекст выполнения правила регистрации.
//      Истина - правило регистрации выполняется в контексте выгрузки объекта.
//      Ложь - правило регистрации выполняется в контексте перед записью объекта
//  ИмяИзмерения - Строка - Имя измерения, ограничивающееся по типу
//  ИмяТипа - Строка - Имя типа, ограничивающее изменение записи регистра сведений
//
Процедура ОграничитьРегистрациюРегистраСведенийПоТипуИзмерения(ИмяПланаОбмена, Отказ, Объект, ОбъектМетаданных, Выгрузка, ИмяИзмерения, ИмяТипа) Экспорт
	
	Для Каждого Запись Из Объект Цикл
		Если ТипЗнч(Запись[ИмяИзмерения]) <> Тип(ИмяТипа) Тогда
			Отказ = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// Обработчик регистрации изменений для начальной выгрузки данных.
// Используется для переопределения стандартной обработки регистрации изменений.
// При стандартной обработке будут зарегистрированы изменения всех данных из состава плана обмена.
// Если для плана обмена предусмотрены фильтры ограничения миграции данных,
// то использование этого обработчика позволит повысить производительность начальной выгрузки данных.
// В обработчике следует реализовать регистрацию изменений с учетом фильтров ограничения миграции данных.
// Если для плана обмена используются ограничения миграции по дате или по дате и организациям,
// то можно воспользоваться универсальной процедурой
// ОбменДаннымиСервер.ЗарегистрироватьДанныеПоДатеНачалаВыгрузкиИОрганизациям.
// Обработчик используется только для универсального обмена данными с использованием правил обмена
// и для универсального обмена данными без правил обмена и не используется для обменов в РИБ.
// Использование обработчика позволяет повысить производительность
// начальной выгрузки данных в среднем в 2-4 раза.
//
// Параметры:
//
// Получатель - ПланОбменаСсылка - Узел плана обмена, в который требуется выгрузить данные.
//
// СтандартнаяОбработка - Булево - В данный параметр передается признак выполнения стандартной (системной) обработки
//                                 события.
//  Если в теле процедуры-обработчика установить данному параметру значение Ложь, стандартная обработка события
//  производиться не будет.
//  Отказ от стандартной обработки не отменяет действие.
//  Значение по умолчанию - Истина.
//
Процедура ОбработкаРегистрацииНачальнойВыгрузкиДанных(Знач Получатель, СтандартнаяОбработка, Отбор) Экспорт
	ОбменДаннымиЗарплатаКадрыВнутренний.ОбработкаРегистрацииНачальнойВыгрузкиДанных(Получатель, СтандартнаяОбработка, Отбор);
КонецПроцедуры

// Процедура обновляет вторичные данные использования обмена данными
// Параметры
//	ИмяПланаОбмена - имя плана обмена для которого выполняется запись вторичных данных
//	КонстантаМенеджер - тип КонстантаМенеджер, в которой хранится настройка использования обмена по всем организациям
//	НаборЗаписей - набор записей регистра сведений, в котором хранятся настройки использования обмена в разрезе организаций
//	СсылкаНаУдаляемыйУзел - ссылка на узел плана обмена при обработке удаления которого вызвана эта процедура
//
Процедура ОбновитьНастройкиИспользованияОбменаДанными(ИмяПланаОбмена, КонстантаМенеджер, НаборЗаписей, СсылкаНаУдаляемыйУзел = Неопределено) Экспорт

	ПолноеИмяПланаОбмена = "ПланОбмена."+ИмяПланаОбмена;
	
	ИсключаемыеУзлы = Новый Массив;
	ИсключаемыеУзлы.Добавить(ПланыОбмена[ИмяПланаОбмена].ЭтотУзел());
	Если СсылкаНаУдаляемыйУзел <> Неопределено Тогда
		ИсключаемыеУзлы.Добавить(СсылкаНаУдаляемыйУзел);	
	КонецЕсли;	
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ИсключаемыеУзлы", ИсключаемыеУзлы);
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ПланыОбменов.ИспользоватьОтборПоОрганизациям
	|ИЗ
	|	#ПолноеИмяПланаОбмена КАК ПланыОбменов
	|ГДЕ
	|	НЕ ПланыОбменов.Ссылка В (&ИсключаемыеУзлы)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МИНИМУМ(ПланыОбменов.ИспользоватьОтборПоОрганизациям) КАК ИспользоватьОтборПоОрганизациям
	|ИЗ
	|	#ПолноеИмяПланаОбмена КАК ПланыОбменов
	|ГДЕ
	|	НЕ ПланыОбменов.Ссылка В (&ИсключаемыеУзлы)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Организации.Организация,
	|	ИСТИНА КАК Используется
	|ИЗ
	|	#ТаблицаОрганизации КАК Организации
	|ГДЕ
	|	НЕ Организации.Ссылка В (&ИсключаемыеУзлы)";
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "#ПолноеИмяПланаОбмена", ПолноеИмяПланаОбмена);
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "#ТаблицаОрганизации", ПолноеИмяПланаОбмена + ".Организации");
	Результат = Запрос.ВыполнитьПакет();
	
	Выборка = Результат[1].Выбрать();
	Выборка.Следующий();
	
	ЗначениеОтборПоВсемОрганизациям = Ложь;
	
	Если Результат[0].Пустой() Тогда
		// нет настроенных узлов обмена, не меняем значения по умолчанию
	ИначеЕсли Не Выборка.ИспользоватьОтборПоОрганизациям Тогда
		ЗначениеОтборПоВсемОрганизациям = Истина;
	Иначе
		// включен отбор по организациям, заполним список выбранных организаций
		НаборЗаписей.Загрузить(Результат[2].Выгрузить());
	КонецЕсли;
	
	КонстантаМенеджер.Установить(ЗначениеОтборПоВсемОрганизациям);
	НаборЗаписей.Записать();

КонецПроцедуры

#КонецОбласти

